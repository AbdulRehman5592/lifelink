import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/providers/chatbot_provider.dart';
import 'package:provider/provider.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController inputController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMessagesSection(context),
            _buildSuggestedQuestions(context),
            _buildInputSection(context, inputController),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF00A89D), Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Online — Ready to help',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesSection(BuildContext context) {
    return Expanded(
      child: Consumer<ChatbotProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: provider.messages.length + (provider.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              // Show typing indicator
              if (index == provider.messages.length) {
                return _buildTypingIndicator();
              }

              final message = provider.messages[index];
              final isUser = message.role == 'user';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      _buildBotAvatar(),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF00A89D)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                            bottomRight: isUser
                                ? const Radius.circular(4)
                                : const Radius.circular(16),
                          ),
                          border: isUser
                              ? null
                              : Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                          boxShadow: isUser
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Text(
                          message.content,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.5,
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 8),
                      _buildUserAvatar(),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF00A89D).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.auto_awesome,
        size: 18,
        color: Color(0xFF00A89D),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF00A89D),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBouncingDot(0),
                const SizedBox(width: 4),
                _buildBouncingDot(150),
                const SizedBox(width: 4),
                _buildBouncingDot(300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(delayMs),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -8 * (1 - (value - 0.5).abs() * 2).clamp(0.0, 1.0)),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestedQuestions(BuildContext context) {
    return Consumer<ChatbotProvider>(
      builder: (context, provider, child) {
        if (!provider.showSuggestions) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suggested questions',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.suggestedQuestions.map((question) {
                  return InkWell(
                    onTap: () {
                      Provider.of<ChatbotProvider>(context, listen: false)
                          .sendMessage(question);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A89D).withOpacity(0.08),
                        border: Border.all(
                          color: const Color(0xFF00A89D).withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        question,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF00A89D),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputSection(
      BuildContext context, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Consumer<ChatbotProvider>(
              builder: (context, provider, child) {
                controller.value = TextEditingValue(
                  text: provider.inputText,
                  selection: TextSelection.collapsed(
                    offset: provider.inputText.length,
                  ),
                );

                return TextField(
                  controller: controller,
                  onChanged: (value) {
                    Provider.of<ChatbotProvider>(context, listen: false)
                        .setInputText(value);
                  },
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty &&
                        !provider.isTyping) {
                      Provider.of<ChatbotProvider>(context, listen: false)
                          .sendMessage(value);
                      controller.clear();
                    }
                  },
                  enabled: !provider.isTyping,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color(0xFF00A89D).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Consumer<ChatbotProvider>(
            builder: (context, provider, child) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: provider.inputText.trim().isNotEmpty &&
                          !provider.isTyping
                      ? () {
                          Provider.of<ChatbotProvider>(context,
                                  listen: false)
                              .sendMessage(provider.inputText);
                          controller.clear();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: provider.inputText.trim().isNotEmpty &&
                              !provider.isTyping
                          ? const Color(0xFF00A89D)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: provider.inputText.trim().isNotEmpty &&
                              !provider.isTyping
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
