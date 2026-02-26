import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/assistant/presentation/state/assistant_state.dart';
import 'package:mediconnect/features/assistant/presentation/view_model/assistant_view_model.dart';

class MedicalAssistantScreen extends ConsumerStatefulWidget {
  const MedicalAssistantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MedicalAssistantScreen> createState() =>
      _MedicalAssistantScreenState();
}

class _MedicalAssistantScreenState extends ConsumerState<MedicalAssistantScreen> {
  late TextEditingController _inputController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.microtask(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantViewModelProvider);
    final viewModel = ref.read(assistantViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FA3F5),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Medical AI Assistance'),
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: Column(
        children: [
          // Emergency Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFFFECA5D),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFF87171),
                  size: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Urgent: In case of life-threatening symptoms, dial emergency services immediately.',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color: const Color(0xF87171),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Messages Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                final isUser = message.role == 'user';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEFF6FF), Color(0xFFDEEBFF)],
                            ),
                            border: Border.all(
                              color: const Color(0xFF4FA3F5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            color: Color(0xFF4FA3F5),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFF4FA3F5)
                                    : const Color(0xFFF1F5F9),
                                border: !isUser
                                    ? Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(16).copyWith(
                                  topRight: isUser ? Radius.zero : null,
                                  topLeft: !isUser ? Radius.zero : null,
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white
                                      : const Color(0xFF334155),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${isUser ? 'Sent' : 'Assistant'} • ${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFFCBD5E1),
                                    letterSpacing: 0.3,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          // Loading Indicator
          if (state.status == AssistantStatus.loading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFF6FF), Color(0xFFDEEBFF)],
                      ),
                      border: Border.all(
                        color: const Color(0xFF4FA3F5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: Color(0xFF4FA3F5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        topLeft: Radius.zero,
                      ),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: _buildAnimatedDot(i),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          'Analyzing medical data...',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF94A3B8),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Input Area
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _inputController,
                  enabled: state.status != AssistantStatus.loading,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText:
                        "Describe symptoms (e.g., 'Sharp abdominal pain for 2 hours')",
                    hintStyle: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF4FA3F5),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _inputController.text.isEmpty ||
                                  state.status == AssistantStatus.loading
                              ? null
                              : () {
                                  final question = _inputController.text;
                                  _inputController.clear();
                                  viewModel.askAssistant(question);
                                  _scrollToBottom();
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _inputController.text.isEmpty ||
                                      state.status == AssistantStatus.loading
                                  ? const Color(0xFFE2E8F0)
                                  : const Color(0xFF4FA3F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.send,
                              color: _inputController.text.isEmpty ||
                                      state.status == AssistantStatus.loading
                                  ? const Color(0xFF94A3B8)
                                  : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Information provided by this AI is for educational purposes and not a substitute for professional medical advice.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
