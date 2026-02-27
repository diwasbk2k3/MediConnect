import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';
import 'package:mediconnect/features/assistant/domain/usecases/ask_medical_assistant_usecase.dart';
import 'package:mediconnect/features/assistant/presentation/state/assistant_state.dart';
import 'package:mediconnect/features/assistant/presentation/view_model/assistant_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAskMedicalAssistantUsecase extends Mock
    implements AskMedicalAssistantUsecase {}

final tBotMessage = AssistantMessageEntity(
  id: 'msg123',
  role: 'bot',
  text: 'Based on your symptoms, you may have a common cold.',
  timestamp: DateTime(2026, 3, 15),
  isEmergency: false,
);

final tEmergencyMessage = AssistantMessageEntity(
  id: 'msg124',
  role: 'bot',
  text: 'This sounds like an emergency. Please seek immediate medical attention.',
  timestamp: DateTime(2026, 3, 15),
  isEmergency: true,
);

void main() {
  late MockAskMedicalAssistantUsecase mockAskMedicalAssistantUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const AskMedicalAssistantUsecaseParams(question: 'fallback'),
    );
  });

  setUp(() {
    mockAskMedicalAssistantUsecase = MockAskMedicalAssistantUsecase();

    container = ProviderContainer(
      overrides: [
        askMedicalAssistantUsecaseProvider
            .overrideWithValue(mockAskMedicalAssistantUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AssistantViewModel', () {
    group('initial state', () {
      test('should have initial state with welcome message', () {
        final state = container.read(assistantViewModelProvider);

        expect(state.messages, isNotEmpty);
        expect(state.messages.first.role, 'bot');
        expect(state.messages.first.text, contains('Welcome'));
        expect(state.errorMessage, isNull);
      });
    });

    group('askAssistant', () {
      test(
          'should add user message and bot response when question is successful',
          () async {
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => Right(tBotMessage));

        final viewModel = container.read(assistantViewModelProvider.notifier);
        final initialMessagesCount =
            container.read(assistantViewModelProvider).messages.length;

        await viewModel.askAssistant('I have a headache');

        final state = container.read(assistantViewModelProvider);

        // Should have welcome + user + bot messages
        expect(state.messages.length, initialMessagesCount + 2);
        expect(state.status, AssistantStatus.success);
        expect(state.messages[state.messages.length - 1].role, 'bot');
        expect(state.messages[state.messages.length - 1].text,
            'Based on your symptoms, you may have a common cold.');
      });

      test('should add user message and error message when request fails',
          () async {
        const failure = ApiFailure(message: 'Connection failed');
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(assistantViewModelProvider.notifier);
        final initialMessagesCount =
            container.read(assistantViewModelProvider).messages.length;

        await viewModel.askAssistant('I have a fever');

        final state = container.read(assistantViewModelProvider);

        // Should have welcome + user + error message
        expect(state.messages.length, initialMessagesCount + 2);
        expect(state.status, AssistantStatus.error);
        expect(state.errorMessage, 'Connection failed');
        expect(state.messages[state.messages.length - 1].text,
            contains('Unable to connect'));
      });

      test('should set isEmergency flag when bot message is emergency',
          () async {
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => Right(tEmergencyMessage));

        final viewModel = container.read(assistantViewModelProvider.notifier);

        await viewModel.askAssistant('I am experiencing chest pain');

        final state = container.read(assistantViewModelProvider);

        expect(state.isEmergency, true);
        expect(state.status, AssistantStatus.success);
      });

      test('should pass question correctly to usecase', () async {
        AskMedicalAssistantUsecaseParams? capturedParams;
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as AskMedicalAssistantUsecaseParams;
          return Future.value(Right(tBotMessage));
        });

        final viewModel = container.read(assistantViewModelProvider.notifier);

        await viewModel.askAssistant('What should I do for allergies?');

        expect(capturedParams?.question, 'What should I do for allergies?');
      });

      test('should transition through loading state', () async {
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => Right(tBotMessage));

        final viewModel = container.read(assistantViewModelProvider.notifier);
        final states = <AssistantState>[];

        final askFuture = viewModel.askAssistant('I have a cough');

        states.add(container.read(assistantViewModelProvider));
        await askFuture;
        states.add(container.read(assistantViewModelProvider));

        expect(states[0].status, AssistantStatus.loading);
        expect(states[1].status, AssistantStatus.success);
      });

      test('should preserve message history', () async {
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => Right(tBotMessage));

        final viewModel = container.read(assistantViewModelProvider.notifier);

        await viewModel.askAssistant('First question');
        var state = container.read(assistantViewModelProvider);
        final firstMessagesCount = state.messages.length;

        await viewModel.askAssistant('Second question');
        state = container.read(assistantViewModelProvider);

        expect(state.messages.length, greaterThan(firstMessagesCount));
      });
    });

    group('reset', () {
      test('should reset to initial state with welcome message', () async {
        when(() => mockAskMedicalAssistantUsecase(any()))
            .thenAnswer((_) async => Right(tBotMessage));

        final viewModel = container.read(assistantViewModelProvider.notifier);

        await viewModel.askAssistant('I have a headache');

        var state = container.read(assistantViewModelProvider);
        expect(state.messages.length, greaterThan(1));

        viewModel.reset();

        state = container.read(assistantViewModelProvider);

        expect(state.messages.length, 1);
        expect(state.messages.first.role, 'bot');
        expect(state.messages.first.text, contains('Welcome'));
      });
    });
  });
}
