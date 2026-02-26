import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';

abstract class AssistantRepository {
  Future<Either<Failure, AssistantMessageEntity>> askMedicalAssistant(
    String question,
  );
}
