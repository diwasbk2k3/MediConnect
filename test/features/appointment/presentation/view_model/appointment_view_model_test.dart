import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:mediconnect/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:mediconnect/features/appointment/domain/usecases/get_appointments_by_status_usecase.dart';
import 'package:mediconnect/features/appointment/presentation/state/appointment_state.dart';
import 'package:mediconnect/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockBookAppointmentUsecase extends Mock implements BookAppointmentUsecase {}

class MockGetAppointmentsByStatusUsecase extends Mock
    implements GetAppointmentsByStatusUsecase {}

class MockCancelAppointmentUsecase extends Mock
    implements CancelAppointmentUsecase {}

const tAppointment = AppointmentEntity(
  appointmentId: 'apt123',
  hospitalId: 'hosp123',
  department: 'Cardiology',
  appointmentType: 'Consultation',
  appointmentDate: '2026-03-15',
  appointmentTime: '10:00 AM',
  paymentAmount: 500.0,
  status: 'upcoming',
);

final tAppointmentList = [tAppointment];

void main() {
  late MockBookAppointmentUsecase mockBookAppointmentUsecase;
  late MockGetAppointmentsByStatusUsecase mockGetAppointmentsByStatusUsecase;
  late MockCancelAppointmentUsecase mockCancelAppointmentUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      BookAppointmentUsecaseParams(
        hospitalId: 'fallback',
        department: 'fallback',
        appointmentType: 'fallback',
        appointmentDate: 'fallback',
        appointmentTime: 'fallback',
        paymentAmount: 0.0,
      ),
    );
    registerFallbackValue(
      const GetAppointmentsByStatusUsecaseParams(status: 'fallback'),
    );
    registerFallbackValue(
      const CancelAppointmentUsecaseParams(
        appointmentId: 'fallback',
        cancellationReason: 'fallback',
      ),
    );
  });

  setUp(() {
    mockBookAppointmentUsecase = MockBookAppointmentUsecase();
    mockGetAppointmentsByStatusUsecase = MockGetAppointmentsByStatusUsecase();
    mockCancelAppointmentUsecase = MockCancelAppointmentUsecase();

    container = ProviderContainer(
      overrides: [
        bookAppointmentUsecaseProvider
            .overrideWithValue(mockBookAppointmentUsecase),
        getAppointmentsByStatusUsecaseProvider
            .overrideWithValue(mockGetAppointmentsByStatusUsecase),
        cancelAppointmentUsecaseProvider
            .overrideWithValue(mockCancelAppointmentUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AppointmentViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        final state = container.read(appointmentViewModelProvider);

        expect(state.status, AppointmentStatus.initial);
        expect(state.appointment, isNull);
        expect(state.appointments, isEmpty);
        expect(state.errorMessage, isNull);
      });
    });

    group('bookAppointment', () {
      test('should emit success state when appointment booking succeeds',
          () async {
        when(() => mockBookAppointmentUsecase(any()))
            .thenAnswer((_) async => const Right(tAppointment));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.bookAppointment(
          hospitalId: 'hosp123',
          department: 'Cardiology',
          appointmentType: 'Consultation',
          appointmentDate: '2026-03-15',
          appointmentTime: '10:00 AM',
          paymentAmount: 500.0,
        );

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.success);
        expect(state.appointment, tAppointment);
        expect(state.successMessage, 'Appointment booked successfully!');
        verify(() => mockBookAppointmentUsecase(any())).called(1);
      });

      test('should emit error state when appointment booking fails', () async {
        const failure = ApiFailure(message: 'Booking failed');
        when(() => mockBookAppointmentUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.bookAppointment(
          hospitalId: 'hosp123',
          department: 'Cardiology',
          appointmentType: 'Consultation',
          appointmentDate: '2026-03-15',
          appointmentTime: '10:00 AM',
          paymentAmount: 500.0,
        );

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.error);
        expect(state.errorMessage, 'Booking failed');
      });

      test('should transition through loading state during booking', () async {
        when(() => mockBookAppointmentUsecase(any()))
            .thenAnswer((_) async => const Right(tAppointment));

        final viewModel = container.read(appointmentViewModelProvider.notifier);
        final states = <AppointmentState>[];

        final bookFuture = viewModel.bookAppointment(
          hospitalId: 'hosp123',
          department: 'Cardiology',
          appointmentType: 'Consultation',
          appointmentDate: '2026-03-15',
          appointmentTime: '10:00 AM',
          paymentAmount: 500.0,
        );

        states.add(container.read(appointmentViewModelProvider));
        await bookFuture;
        states.add(container.read(appointmentViewModelProvider));

        expect(states[0].status, AppointmentStatus.loading);
        expect(states[1].status, AppointmentStatus.success);
      });
    });

    group('getAppointmentsByStatus', () {
      test('should emit success state when fetching appointments succeeds',
          () async {
        when(() => mockGetAppointmentsByStatusUsecase(any()))
            .thenAnswer((_) async => Right(tAppointmentList));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.getAppointmentsByStatus('not-visited');

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.success);
        expect(state.appointments, tAppointmentList);
        verify(() => mockGetAppointmentsByStatusUsecase(any())).called(1);
      });

      test('should emit error state when fetching appointments fails', () async {
        const failure = ApiFailure(message: 'Failed to fetch appointments');
        when(() => mockGetAppointmentsByStatusUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.getAppointmentsByStatus('not-visited');

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.error);
        expect(state.errorMessage, 'Failed to fetch appointments');
      });

      test('should pass status correctly to usecase', () async {
        GetAppointmentsByStatusUsecaseParams? capturedParams;
        when(() => mockGetAppointmentsByStatusUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as GetAppointmentsByStatusUsecaseParams;
          return Future.value(Right(tAppointmentList));
        });

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.getAppointmentsByStatus('visited');

        expect(capturedParams?.status, 'visited');
      });

      test('should transition through loading state during fetch', () async {
        when(() => mockGetAppointmentsByStatusUsecase(any()))
            .thenAnswer((_) async => Right(tAppointmentList));

        final viewModel = container.read(appointmentViewModelProvider.notifier);
        final states = <AppointmentState>[];

        final fetchFuture = viewModel.getAppointmentsByStatus('not-visited');

        states.add(container.read(appointmentViewModelProvider));
        await fetchFuture;
        states.add(container.read(appointmentViewModelProvider));

        expect(states[0].status, AppointmentStatus.loading);
        expect(states[1].status, AppointmentStatus.success);
      });
    });

    group('cancelAppointment', () {
      test('should emit success state when cancellation succeeds', () async {
        when(() => mockCancelAppointmentUsecase(any()))
            .thenAnswer((_) async => const Right(true));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.cancelAppointment(
          appointmentId: 'apt123',
          cancellationReason: 'Emergency',
        );

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.success);
        expect(state.successMessage, 'Appointment cancelled successfully!');
      });

      test('should emit error state when cancellation fails', () async {
        const failure = ApiFailure(message: 'Cancellation failed');
        when(() => mockCancelAppointmentUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.cancelAppointment(
          appointmentId: 'apt123',
          cancellationReason: 'Emergency',
        );

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.error);
        expect(state.errorMessage, 'Cancellation failed');
      });

      test('should pass parameters correctly to usecase', () async {
        CancelAppointmentUsecaseParams? capturedParams;
        when(() => mockCancelAppointmentUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as CancelAppointmentUsecaseParams;
          return Future.value(const Right(true));
        });

        final viewModel = container.read(appointmentViewModelProvider.notifier);

        await viewModel.cancelAppointment(
          appointmentId: 'apt123',
          cancellationReason: 'Emergency',
        );

        expect(capturedParams?.appointmentId, 'apt123');
        expect(capturedParams?.cancellationReason, 'Emergency');
      });

      test('should transition through loading state during cancellation',
          () async {
        when(() => mockCancelAppointmentUsecase(any()))
            .thenAnswer((_) async => const Right(true));

        final viewModel = container.read(appointmentViewModelProvider.notifier);
        final states = <AppointmentState>[];

        final cancelFuture = viewModel.cancelAppointment(
          appointmentId: 'apt123',
          cancellationReason: 'Emergency',
        );

        states.add(container.read(appointmentViewModelProvider));
        await cancelFuture;
        states.add(container.read(appointmentViewModelProvider));

        expect(states[0].status, AppointmentStatus.loading);
        expect(states[1].status, AppointmentStatus.success);
      });
    });

    group('resetMessages', () {
      test('should reset messages', () {
        final viewModel = container.read(appointmentViewModelProvider.notifier);

        // First set some messages
        viewModel.resetMessages();

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.initial);
      });
    });

    group('resetState', () {
      test('should reset state to initial', () {
        final viewModel = container.read(appointmentViewModelProvider.notifier);

        viewModel.resetState();

        final state = container.read(appointmentViewModelProvider);
        expect(state.status, AppointmentStatus.initial);
        expect(state.appointment, isNull);
        expect(state.appointments, isEmpty);
      });
    });
  });
}
