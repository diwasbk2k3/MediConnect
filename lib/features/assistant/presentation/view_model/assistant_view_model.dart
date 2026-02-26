import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:mediconnect/features/assistant/domain/usecases/ask_medical_assistant_usecase.dart';
import 'package:mediconnect/features/assistant/presentation/state/assistant_state.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';

final assistantViewModelProvider =
    NotifierProvider<AssistantViewModel, AssistantState>(
        () => AssistantViewModel());

class AssistantViewModel extends Notifier<AssistantState> {
  late final AskMedicalAssistantUsecase _askMedicalAssistantUsecase;

  @override
  AssistantState build() {
    _askMedicalAssistantUsecase =
        ref.read(askMedicalAssistantUsecaseProvider);
    return AssistantState(
      messages: [
        AssistantMessageEntity(
          id: '0',
          role: 'bot',
          text:
              'Welcome to the Medical Assistant. Please describe your symptoms or medical concerns in detail.',
          timestamp: DateTime.now(),
          isEmergency: false,
        ),
      ],
    );
  }

  Future<void> askAssistant(String question) async {
    // Add user message
    final userMessage = AssistantMessageEntity(
      id: const Uuid().v4(),
      role: 'user',
      text: question,
      timestamp: DateTime.now(),
      isEmergency: false,
    );

    state = state.copyWith(
      status: AssistantStatus.loading,
      messages: [...state.messages, userMessage],
    );

    // Call usecase
    final result = await _askMedicalAssistantUsecase(
      AskMedicalAssistantUsecaseParams(question: question),
    );

    result.fold(
      (failure) {
        final errorMessage = AssistantMessageEntity(
          id: const Uuid().v4(),
          role: 'bot',
          text:
              'Unable to connect to the medical assistant. Please try again later.',
          timestamp: DateTime.now(),
          isEmergency: false,
        );

        state = state.copyWith(
          status: AssistantStatus.error,
          messages: [...state.messages, errorMessage],
          errorMessage: failure.message,
        );
      },
      (botMessage) {
        state = state.copyWith(
          status: AssistantStatus.success,
          messages: [...state.messages, botMessage],
          isEmergency: botMessage.isEmergency,
        );
      },
    );
  }

  void reset() {
    state = AssistantState(
      messages: [
        AssistantMessageEntity(
          id: '0',
          role: 'bot',
          text:
              'Welcome to the Medical Assistant. Please describe your symptoms or medical concerns in detail.',
          timestamp: DateTime.now(),
          isEmergency: false,
        ),
      ],
    );
  }
}
