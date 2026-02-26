import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/assistant/data/repositories/assistant_repository.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';
import 'package:mediconnect/features/assistant/domain/repositories/assistant_repository.dart';

// Provider
final askMedicalAssistantUsecaseProvider = Provider<AskMedicalAssistantUsecase>((ref) {
  final repository = ref.read(assistantRepositoryProvider);
  return AskMedicalAssistantUsecase(repository: repository);
});

class AskMedicalAssistantUsecaseParams extends Equatable {
  final String question;

  const AskMedicalAssistantUsecaseParams({required this.question});

  @override
  List<Object?> get props => [question];
}

class AskMedicalAssistantUsecase
    implements UseCaseWithParams<AssistantMessageEntity, AskMedicalAssistantUsecaseParams> {
  final AssistantRepository _repository;

  AskMedicalAssistantUsecase({required AssistantRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AssistantMessageEntity>> call(
      AskMedicalAssistantUsecaseParams params) async {
    return await _repository.askMedicalAssistant(params.question);
  }
}
