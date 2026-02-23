import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../repositories/blood_repository.dart';
import '../repositories/medicine_repository.dart';

class ChatMessage {
  final String id;
  final String role; // 'user', 'assistant', or 'system' (for context)
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final timestamp = map['timestamp'];
    DateTime parsedTimestamp;

    if (timestamp is DateTime) {
      parsedTimestamp = timestamp;
    } else if (timestamp is int) {
      parsedTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      // Handle Firestore Timestamp if needed (requires cloud_firestore import)
      // For now, default to current time
      parsedTimestamp = DateTime.now();
    }

    return ChatMessage(
      id: map['id'],
      role: map['role'],
      content: map['content'],
      timestamp: parsedTimestamp,
    );
  }
}

class ChatbotProvider with ChangeNotifier {
  final GenerativeModel _model;

  // Repositories
  final BloodRepository _bloodRepository = BloodRepository();
  final MedicineRepository _medicineRepository = MedicineRepository();

  // System prompt for intent classification and context-based responses
  static const String _systemPrompt = '''
You are an expert intent classifier and helpful assistant for LifeLink, a healthcare platform.

Your role:
1. Analyze user input to determine if it's a COMMAND or a QUESTION.
2. COMMANDS are direct requests to perform specific actions in the app.
3. QUESTIONS are general inquiries, explanations, or information requests.

COMMAND Examples:
- "get donors", "show me donors", "find donors", "list blood donors" → COMMAND:GETDONORS
- "show available medicines", "list medicines", "find medicine" → COMMAND:GETMEDICINES
- "my donations", "donation history", "show my activity" → COMMAND:MYDONATIONS

QUESTION Examples:
- "How can I donate blood?", "What are the requirements?", "Tell me about blood donation" → Answer normally
- "Where can I find medicine banks?", "How does medicine sharing work?" → Answer normally
- "What is organ donation?", "Who can be a donor?" → Answer normally

IMPORTANT OUTPUT RULES:
- If user input is a COMMAND, output ONLY: "COMMAND:<COMMAND_NAME>" (e.g., "COMMAND:GETDONORS")
- If user input is a QUESTION, respond normally with helpful information
- Do not add extra explanations for commands
- For commands, be concise and accurate with the command format
- For questions, be friendly, helpful, and thorough

CRITICAL: WHEN RESPONDING WITH DATA CONTEXT:
If the user message contains a [DATA CONTEXT] section, you MUST use that data to answer the user's question. The [DATA CONTEXT] contains real data from Firestore.

Rules for responding with data context:
1. CRITICAL: Read the [DATA CONTEXT] section carefully
2. Present the information from the data context in a clear, user-friendly format
3. ALWAYS include the donor's FULL NAME prominently in your response
4. Highlight relevant details (blood types, availability, expiry dates, etc.)
5. Format donor/medicine information as a clean, readable list
6. Use emojis to make the response engaging (🩸 for blood, 💊 for medicines, ✅ for available items)
7. If the user asked for specific criteria (e.g., blood type B+), focus on those results
8. Be conversational and helpful - talk to the user naturally
9. If no data is available, politely inform the user
10. NEVER output "COMMAND:" when you have data context - answer the question naturally using the provided data

Donor Response Format Example:
🩸 Here are the available donors:

1. **John Doe** - Blood Type: B+ ✅
   - Status: Available
   - Gender: Male

2. **Jane Smith** - Blood Type: B+ ✅
   - Status: Available
   - Gender: Female

Medicine Response Format Example:
💊 Here are the available medicines:

1. **Panadol Extra** (Paracetamol) ✅
   - Category: Painkillers
   - Quantity: 20 units
   - Expires: Dec 2025
   - Donor: City Pharmacy
   - Distance: 1.2 km
''';

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'welcome',
      role: 'assistant',
      content:
          'Hello! 👋 I\'m your LifeLink AI assistant. I can help you with blood donation, medicine sharing, organ registry, and more. How can I assist you today?',
      timestamp: DateTime.now(),
    ),
  ];

  final List<String> _suggestedQuestions = [
    'How can I donate blood?',
    'Find nearby medicine banks',
    'Organ donation eligibility',
    'Check my donation history',
  ];

  bool _isTyping = false;
  String _inputText = '';

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  String get inputText => _inputText;
  List<String> get suggestedQuestions => _suggestedQuestions;

  bool get showSuggestions => _messages.length <= 1;

  ChatbotProvider({String modelName = 'gemini-2.5-flash'})
      : _model = FirebaseAI.googleAI().generativeModel(model: modelName);

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: text.trim(),
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _inputText = '';
    _isTyping = true;
    notifyListeners();

    // Fetch LLM response
    _fetchLLMResponse(text);
  }

  /// Parse command from LLM response
  /// Returns command if the response is ONLY a command, null otherwise
  String? _parseCommand(String? response) {
    if (response == null) return null;

    final trimmed = response.trim();

    // Check if response starts with command format and is short (just the command)
    if ((trimmed.startsWith('COMMAND:') || trimmed.startsWith('command:')) &&
        trimmed.length < 20) {

      return trimmed;
    }

    return null; // Not a pure command - it's a normal response
  }

  /// Fetch response from Google Generative AI
  Future<void> _fetchLLMResponse(String userMessage) async {
    try {
      // Build conversation history for context (exclude system messages)
      final history = [
        Content.text(_systemPrompt),
        ..._messages
            .take(10)
            .where((msg) => msg.id != 'welcome' && msg.role != 'system')
            .map((msg) => Content.text(msg.content)),
      ];

      // Create chat session with history
      final chat = _model.startChat(history: history);

      // Send user message and get response
      final response = await chat.sendMessage(
        Content.text(userMessage),
      );

      final text = response.text;

      if (text != null && text.isNotEmpty) {
        // Parse command from response
        final command = _parseCommand(text);

        if (command != null && command.contains("COMMAND:")) {
      // Command detected - don't show as message, execute and get natural response
          await _executeCommandAndRespond(command, userMessage);
          return; // Early return - _executeCommandAndRespond handles notifyListeners

        } else {
          // Normal response - add as bot message
            final botMessage = ChatMessage(
            id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            role: 'assistant',
            content: text.trim(),
            timestamp: DateTime.now(),
          );
          _messages.add(botMessage);

        }
      } else {
        throw Exception('Empty response from API');
      }
    } catch (e) {
      debugPrint('LLM API Error: $e');
      // Fall back to simulated response on error
      _getSimulatedResponse(userMessage);
      return; // Early return - _getSimulatedResponse handles notifyListeners
    }

    _isTyping = false;
    notifyListeners();
  }

  /// Execute command and provide natural response from LLM
  Future<void> _executeCommandAndRespond(String command, String originalUserMessage) async {
    try {
      String dataContext;
      final commandName = command.split(':').last.trim().toUpperCase();

      debugPrint('Executing command: $commandName');
      debugPrint('Original user message: $originalUserMessage');

      // Execute appropriate repository method based on command
      switch (commandName) {
        case 'GETDONORS':
          final bloodType = _extractBloodType(originalUserMessage);
          debugPrint('Extracted blood type: $bloodType');
          dataContext = await _getDonorsContext(bloodType: bloodType);
          break;
        case 'GETMEDICINES':
          final category = _extractMedicineCategory(originalUserMessage);
          debugPrint('Extracted medicine category: $category');
          dataContext = await _getMedicinesContext(category: category);
          break;
        case 'MYDONATIONS':
          dataContext = await _getMyDonationsContext();
          break;
        default:
          // Unknown command - show as message
          final errorMsg = ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            role: 'assistant',
            content: 'Sorry, I couldn\'t understand that command. Please try asking differently.',
            timestamp: DateTime.now(),
          );
          _messages.add(errorMsg);
          _isTyping = false;
          notifyListeners();
          return;
      }

      debugPrint('Data context fetched. Length: ${dataContext.length}');
      debugPrint('Data context: $dataContext');

      // Provide context to LLM for natural response
      await _fetchNaturalResponseWithContext(originalUserMessage, dataContext);
    } catch (e) {
      debugPrint('Command execution error: $e');
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: 'Sorry, there was an error processing your request. Please try again.',
        timestamp: DateTime.now(),
      );
      _messages.add(errorMsg);
      _isTyping = false;
      notifyListeners();
    }
  }

  /// Get donors context from repository
  Future<String> _getDonorsContext({String? bloodType}) async {
    final snapshot = await _bloodRepository.getDonors(bloodType: bloodType).first;
    if (snapshot.isEmpty) {
      if (bloodType != null) {
        return 'There are currently no available donors with blood type $bloodType in the system.';
      }
      return 'There are currently no available donors in the system.';
    }

    final donors = snapshot.take(5); // Limit to top 5 for context
    final donorsList = donors.map((d) {
      final statusEmoji = d.isAvailable ? '✅' : '❌';
      final gender = d.gender ?? 'Not specified';
      final availability = d.isAvailable ? 'Available' : 'Not Available';
      final statusStr = d.status.toString().split('.').last;

      return 'Donor Name: ${d.fullName}\n'
          '   Blood Type: ${d.bloodType}\n'
          '   Gender: $gender\n'
          '   Status: $statusStr\n'
          '   Available: $availability ($statusEmoji)';
    }).join('\n\n');

    final title = bloodType != null
        ? '📋 Available Donors List - Blood Type: $bloodType (Showing 5 of ${snapshot.length} donors)'
        : '📋 Available Donors List (Showing 5 of ${snapshot.length} donors)';

    return '$title\n\n$donorsList\n\n'
        '💡 To contact a donor, please use the Blood Donation section in the app where you can view their full profile and send a request.';
  }

  /// Get medicines context from repository
  Future<String> _getMedicinesContext({String? category}) async {
    final snapshot = await _medicineRepository.getMedicines(category: category).first;
    if (snapshot.isEmpty) {
      if (category != null && category != 'all') {
        return 'There are currently no available medicines in the $category category.';
      }
      return 'There are currently no available medicines in the system.';
    }

    final medicines = snapshot.take(5); // Limit to top 5 for context
    final medicinesList = medicines.map((m) {
      final verifiedEmoji = m.verified ? '✅' : '⚠️';
      final verifiedStr = m.verified ? 'Yes' : 'No';

      return '$verifiedEmoji ${m.name} (${m.generic})\n'
          '   - Category: ${m.category}\n'
          '   - Quantity: ${m.quantity} units\n'
          '   - Expires: ${m.expiry}\n'
          '   - Donor: ${m.donor}\n'
          '   - Distance: ${m.distance} km\n'
          '   - Posted: ${_formatDate(m.postedDate)}\n'
          '   - Verified: $verifiedStr';
    }).join('\n\n');

    final title = category != null && category != 'all'
        ? '💊 Available Medicines List - Category: $category (Showing 5 of ${snapshot.length} medicines)'
        : '💊 Available Medicines List (Showing 5 of ${snapshot.length} medicines)';

    return '$title\n\n$medicinesList\n\n'
        '💡 To request a medicine or get more details, please use the Medicine section in the app.';
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Extract blood type from user message
  String? _extractBloodType(String message) {
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    // Normalize the message
    String normalized = message.toUpperCase().replaceAll(' ', '');

    // Try to match blood type patterns
    for (final bloodType in bloodTypes) {
      // Match with or without space (e.g., "B +" or "B+")
      if (normalized.contains(bloodType) ||
          message.toUpperCase().contains('${bloodType[0]} ${bloodType[1]}')) {
        return bloodType;
      }
    }

    return null;
  }

  /// Extract medicine category from user message
  String? _extractMedicineCategory(String message) {
    final categories = {
      'painkiller': 'painkillers',
      'painkillers': 'painkillers',
      'pain': 'painkillers',
      'headache': 'painkillers',
      'antibiotic': 'antibiotics',
      'antibiotics': 'antibiotics',
      'infection': 'antibiotics',
      'vitamin': 'vitamins',
      'vitamins': 'vitamins',
      'supplement': 'vitamins',
      'cold': 'cold_cough',
      'cough': 'cold_cough',
      'allergy': 'allergy',
      'allergies': 'allergy',
    };

    final lowerMessage = message.toLowerCase();
    for (final entry in categories.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Get my donations context (placeholder)
  Future<String> _getMyDonationsContext() async {
    return 'You can check your donation history in the Profile section. It shows your blood donations and medicine contributions.';
  }

  /// Fetch natural response from LLM with data context
  Future<void> _fetchNaturalResponseWithContext(String userMessage, String dataContext) async {
    try {
      // Start a fresh chat session with system prompt only
      // This avoids including command history that might cause the LLM to output commands again
      final chat = _model.startChat(history: [Content.text(_systemPrompt)]);

      // Send user message with data context
      final prompt = '$userMessage\n\n\n[DATA CONTEXT]\n$dataContext\n[/DATA CONTEXT]';

      debugPrint('Sending prompt to LLM with data context...');
      final response = await chat.sendMessage(Content.text(prompt));
      final text = response.text;

      debugPrint('LLM response: $text');

      if (text != null && text.isNotEmpty) {
        final botMessage = ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          role: 'assistant',
          content: text.trim(),
          timestamp: DateTime.now(),
        );
        _messages.add(botMessage);
      }
    } catch (e) {
      debugPrint('Natural response error: $e');
      final errorMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: 'Sorry, I couldn\'t generate a response. Please try again.',
        timestamp: DateTime.now(),
      );
      _messages.add(errorMsg);
    }

    _isTyping = false;
    notifyListeners();
  }

  /// Get simulated response (fallback when API is unavailable)
  void _getSimulatedResponse(String question) {
    Future.delayed(const Duration(milliseconds: 1200), () {
      final botMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: 'assistant',
        content: _getSimulatedResponseText(question),
        timestamp: DateTime.now(),
      );

      _messages.add(botMessage);
      _isTyping = false;
      notifyListeners();
    });
  }

  String _getSimulatedResponseText(String question) {
    final q = question.toLowerCase();

    // Check for commands
    if (q.contains('get donor') || q.contains('show donor') || q.contains('find donor')) {
      return 'COMMAND:GETDONORS';
    }

    if (q.contains('show medicine') || q.contains('list medicine') || q.contains('find medicine')) {
      return 'COMMAND:GETMEDICINES';
    }

    if (q.contains('my donation') || q.contains('donation history') || q.contains('my activity')) {
      return 'COMMAND:MYDONATIONS';
    }

    // Answer questions normally
    if (q.contains('blood') || q.contains('donate')) {
      return 'To donate blood, you need to be at least 17 years old and weigh over 50 kg. You can visit Blood section in app to find nearby donation centers or respond to urgent requests. Would you like me to guide you through the process?';
    }

    if (q.contains('medicine')) {
      return 'You can share unused, unexpired medicines through our Medicine section. Simply list the medicine with its expiry date and location, and those in need can request it. All medicines go through a verification process.';
    }

    if (q.contains('organ')) {
      return 'Organ donation registration is a noble decision. You can register as an organ donor through our Organ section. The process involves filling out a consent form and getting verified. Would you like to know more about eligibility?';
    }

    if (q.contains('history') || q.contains('donation')) {
      return 'You can check your complete donation history in your Profile section. It shows all your blood donations, medicine shares, and any organ registry status. Would you like me to take you there?';
    }

    return "That's a great question! I'm here to help with anything related to blood donation, medicine sharing, organ donation, and medical emergencies. Could you provide more details so I can assist you better?";
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      ChatMessage(
        id: 'welcome',
        role: 'assistant',
        content:
            'Hello! 👋 I\'m your LifeLink AI assistant. I can help you with blood donation, medicine sharing, organ registry, and more. How can I assist you today?',
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
