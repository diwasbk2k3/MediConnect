import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/domain/usecases/get_all_reports_for_patient_usecase.dart';
import 'package:mediconnect/features/report/domain/usecases/get_report_by_appointment_id_usecase.dart';
import 'package:mediconnect/features/report/presentation/state/report_state.dart';
import 'package:mediconnect/features/report/presentation/view_model/report_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetReportByAppointmentIdUsecase extends Mock
    implements GetReportByAppointmentIdUsecase {}

class MockGetAllReportsForPatientUsecase extends Mock
    implements GetAllReportsForPatientUsecase {}

const tReport = ReportEntity(
  reportId: 'report123',
  appointmentId: 'apt123',
  reportUrl: 'https://example.com/report.pdf',
  remarks: 'Patient doing well',
  hospitalUsername: 'drhospital',
  department: 'Cardiology',
  appointmentDate: '2026-03-15',
  appointmentTime: '10:00 AM',
);

final tReportList = <ReportEntity>[tReport];

void main() {
  late MockGetReportByAppointmentIdUsecase
      mockGetReportByAppointmentIdUsecase;
  late MockGetAllReportsForPatientUsecase mockGetAllReportsForPatientUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const GetReportByAppointmentIdUsecaseParams(
        appointmentId: 'fallback',
      ),
    );
  });

  setUp(() {
    mockGetReportByAppointmentIdUsecase =
        MockGetReportByAppointmentIdUsecase();
    mockGetAllReportsForPatientUsecase =
        MockGetAllReportsForPatientUsecase();

    container = ProviderContainer(
      overrides: [
        getReportByAppointmentIdUsecaseProvider
            .overrideWithValue(mockGetReportByAppointmentIdUsecase),
        getAllReportsForPatientUsecaseProvider
            .overrideWithValue(mockGetAllReportsForPatientUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ReportViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        final state = container.read(reportViewModelProvider);

        expect(state.status, ReportStatus.initial);
        expect(state.report, isNull);
        expect(state.reports, isEmpty);
        expect(state.errorMessage, isNull);
      });
    });

    group('getReportByAppointmentId', () {
      test('should emit success state when report fetch succeeds', () async {
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((_) async => const Right(tReport));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getReportByAppointmentId('apt123');

        final state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.success);
        expect(state.report, tReport);
        verify(() => mockGetReportByAppointmentIdUsecase(any())).called(1);
      });

      test('should emit error state when report fetch fails', () async {
        const failure = ApiFailure(message: 'Report not found');
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getReportByAppointmentId('apt123');

        final state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.error);
        expect(state.errorMessage, 'Report not found');
      });

      test('should pass appointmentId correctly to usecase', () async {
        GetReportByAppointmentIdUsecaseParams? capturedParams;
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as GetReportByAppointmentIdUsecaseParams;
          return Future.value(const Right(tReport));
        });

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getReportByAppointmentId('apt456');

        expect(capturedParams?.appointmentId, 'apt456');
      });

      test('should transition through loading state during fetch', () async {
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((_) async => const Right(tReport));

        final viewModel = container.read(reportViewModelProvider.notifier);
        final states = <ReportState>[];

        final fetchFuture = viewModel.getReportByAppointmentId('apt123');

        states.add(container.read(reportViewModelProvider));
        await fetchFuture;
        states.add(container.read(reportViewModelProvider));

        expect(states[0].status, ReportStatus.loading);
        expect(states[1].status, ReportStatus.success);
      });
    });

    group('getAllReportsForPatient', () {
      test('should emit success state when fetching all reports succeeds',
          () async {
        when(() => mockGetAllReportsForPatientUsecase())
            .thenAnswer((_) async => Right(tReportList));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getAllReportsForPatient();

        final state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.success);
        expect(state.reports, tReportList);
        verify(() => mockGetAllReportsForPatientUsecase()).called(1);
      });

      test('should emit error state when fetching all reports fails', () async {
        const failure = ApiFailure(message: 'Failed to fetch reports');
        when(() => mockGetAllReportsForPatientUsecase())
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getAllReportsForPatient();

        final state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.error);
        expect(state.errorMessage, 'Failed to fetch reports');
      });

      test('should return empty list when no reports exist', () async {
        when(() => mockGetAllReportsForPatientUsecase())
            .thenAnswer((_) async => const Right([]));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getAllReportsForPatient();

        final state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.success);
        expect(state.reports, isEmpty);
      });

      test('should transition through loading state during fetch', () async {
        when(() => mockGetAllReportsForPatientUsecase())
            .thenAnswer((_) async => Right(tReportList));

        final viewModel = container.read(reportViewModelProvider.notifier);
        final states = <ReportState>[];

        final fetchFuture = viewModel.getAllReportsForPatient();

        states.add(container.read(reportViewModelProvider));
        await fetchFuture;
        states.add(container.read(reportViewModelProvider));

        expect(states[0].status, ReportStatus.loading);
        expect(states[1].status, ReportStatus.success);
      });

      test('should preserve report details after fetch', () async {
        when(() => mockGetAllReportsForPatientUsecase())
            .thenAnswer((_) async => Right(tReportList));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getAllReportsForPatient();

        final state = container.read(reportViewModelProvider);
        expect(state.reports.first.hospitalUsername, 'drhospital');
        expect(state.reports.first.department, 'Cardiology');
        expect(state.reports.first.remarks, 'Patient doing well');
      });
    });

    group('state transitions', () {
      test(
          'should update to error state when fetching specific report after success',
          () async {
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((_) async => const Right(tReport));

        final viewModel = container.read(reportViewModelProvider.notifier);

        await viewModel.getReportByAppointmentId('apt123');

        var state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.success);

        const failure = ApiFailure(message: 'Error fetching report');
        when(() => mockGetReportByAppointmentIdUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        await viewModel.getReportByAppointmentId('apt456');

        state = container.read(reportViewModelProvider);
        expect(state.status, ReportStatus.error);
        expect(state.errorMessage, 'Error fetching report');
      });
    });
  });
}
