import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';

enum AssistantStatus {
  initial,
  loading,
  success,
  error,
}

class AssistantState extends Equatable {
  final AssistantStatus status;
  final List<AssistantMessageEntity> messages;
  final String? errorMessage;
  final bool isEmergency;

  const AssistantState({
    this.status = AssistantStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.isEmergency = false,
  });

  AssistantState copyWith({
    AssistantStatus? status,
    List<AssistantMessageEntity>? messages,
    String? errorMessage,
    bool? isEmergency,
  }) {
    return AssistantState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmergency: isEmergency ?? this.isEmergency,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage, isEmergency];
}
