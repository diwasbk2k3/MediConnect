import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';

class AssistantMessageModel {
  final String id;
  final String role; // 'user' or 'bot'
  final String text;
  final DateTime timestamp;
  final bool isEmergency;
  final String? disclaimer;

  AssistantMessageModel({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.isEmergency = false,
    this.disclaimer,
  });

  factory AssistantMessageModel.fromJson(Map<String, dynamic> json) {
    return AssistantMessageModel(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      role: json['role'] as String? ?? 'bot',
      text: json['result'] as String? ?? json['text'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      isEmergency: json['isEmergency'] as bool? ?? false,
      disclaimer: json['disclaimer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isEmergency': isEmergency,
      'disclaimer': disclaimer,
    };
  }

  AssistantMessageEntity toEntity() {
    return AssistantMessageEntity(
      id: id,
      role: role,
      text: text,
      timestamp: timestamp,
      isEmergency: isEmergency,
      disclaimer: disclaimer,
    );
  }
}
