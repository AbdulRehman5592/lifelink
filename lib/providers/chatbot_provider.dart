import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
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
    return ChatMessage(
      id: map['id'],
      role: map['role'],
      content: map['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}

class ChatbotProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'welcome',
      role: 'assistant',
      content:
          'Hello! 👋 I\'m your LifeLink AI assistant. I can help you with blood donation, medicine sharing, organ registry, and more. How can I assist you today?',
      timestamp: DateTime.now(),
    ),
  ];

  // Remote Config instance
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

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

    // Check if chatbot is enabled via Remote Config
    final chatbotEnabled = _remoteConfig.getBool('chatbot_enabled');

    if (chatbotEnabled) {
      _fetchLLMResponse(text);
    } else {
      _getSimulatedResponse(text);
    }
  }

  /// Fetch response from LLM API using Remote Config values
  Future<void> _fetchLLMResponse(String userMessage) async {
    final apiKey = _remoteConfig.getString('llm_api_key');
    final apiEndpoint = _remoteConfig.getString('llm_api_endpoint');
    final modelName = _remoteConfig.getString('llm_model_name');

    // If no API key is configured, fall back to simulated response
    if (apiKey.isEmpty) {
      _getSimulatedResponse(userMessage);
      return;
    }

    try {
      // Build conversation history for context
      final messages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': 'You are LifeLink AI assistant, a helpful assistant for a healthcare platform focused on blood donation, medicine sharing, and organ donation. Provide accurate, empathetic responses in a friendly tone.'
        },
        ..._messages.take(10).map((msg) => {
          'role': msg.role,
          'content': msg.content,
        }),
      ];

      final response = await http.post(
        Uri.parse(apiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': modelName,
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botMessage = ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          role: 'assistant',
          content: data['choices'][0]['message']['content'].toString().trim(),
          timestamp: DateTime.now(),
        );

        _messages.add(botMessage);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('LLM API Error: $e');
      // Fall back to simulated response on error
      _getSimulatedResponse(userMessage);
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

    if (q.contains('blood') || q.contains('donate')) {
      return 'To donate blood, you need to be at least 17 years old and weigh over 50 kg. You can visit the Blood section in the app to find nearby donation centers or respond to urgent requests. Would you like me to guide you through the process?';
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

    return "That's a great question! I'm here to help with anything related to blood donation, medicine sharing, organ donation, and medical emergencies in Pakistan. Could you provide more details so I can assist you better?";
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
