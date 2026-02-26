import 'package:equatable/equatable.dart';

class AssistantMessageEntity extends Equatable {
  final String id;
  final String role; // 'user' or 'bot'
  final String text;
  final DateTime timestamp;
  final bool isEmergency;
  final String? disclaimer;

  const AssistantMessageEntity({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.isEmergency = false,
    this.disclaimer,
  });

  AssistantMessageEntity copyWith({
    String? id,
    String? role,
    String? text,
    DateTime? timestamp,
    bool? isEmergency,
    String? disclaimer,
  }) {
    return AssistantMessageEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isEmergency: isEmergency ?? this.isEmergency,
      disclaimer: disclaimer ?? this.disclaimer,
    );
  }

  @override
  List<Object?> get props => [id, role, text, timestamp, isEmergency, disclaimer];
}
