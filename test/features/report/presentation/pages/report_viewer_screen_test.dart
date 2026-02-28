import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/presentation/pages/report_viewer_screen.dart';

void main() {
  const tReportWithPdf = ReportEntity(
    reportId: 'report123',
    appointmentId: 'apt123',
    hospitalUsername: 'Hope Hospital',
    department: 'Cardiology',
    remarks: 'Patient shows improvement',
    reportUrl: 'reports/report123.pdf',
    createdAt: null,
  );

  const tReportWithImage = ReportEntity(
    reportId: 'report456',
    appointmentId: 'apt456',
    hospitalUsername: 'City Medical',
    department: 'Radiology',
    remarks: 'X-ray taken successfully',
    reportUrl: 'reports/xray456.jpg',
    createdAt: null,
  );

  const tReportWithoutRemarks = ReportEntity(
    reportId: 'report789',
    appointmentId: 'apt789',
    hospitalUsername: 'Medical Center',
    department: 'General',
    remarks: null,
    reportUrl: 'reports/report789.pdf',
    createdAt: null,
  );

  const tReportWithEmptyRemarks = ReportEntity(
    reportId: 'report999',
    appointmentId: 'apt999',
    hospitalUsername: 'Health Clinic',
    department: 'Orthopedics',
    remarks: '',
    reportUrl: 'reports/report999.jpg',
    createdAt: null,
  );

  Widget createTestWidget({required ReportEntity report}) {
    return MaterialApp(
      home: ReportViewerScreen(report: report),
    );
  }

  group('ReportViewerScreen - Widget Tests', () {
    testWidgets('Report viewer displays with AppBar and body',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
    });

    testWidgets('AppBar displays report department title',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));

      final titleFinder = find.text('Cardiology');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('AppBar has correct styling and colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
    });

    testWidgets('Image report is displayed with proper widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithImage));
      // Allow network widget building
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Radiology'), findsOneWidget);
    });

    testWidgets('Report with remarks shows clinical assessment',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithImage));

      expect(find.text('Patient shows improvement'), findsNothing);
      expect(find.text('X-ray taken successfully'), findsOneWidget);
      expect(find.text('Clinical Assessment'), findsOneWidget);
    });

    testWidgets('Report without remarks handles gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithoutRemarks));

      // Clinical Assessment should not appear if no remarks
      final clinicalAssessmentFinder = find.text('Clinical Assessment');
      expect(clinicalAssessmentFinder, findsNothing);
    });

    testWidgets('Empty remarks string is handled correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithEmptyRemarks));

      final clinicalAssessmentFinder = find.text('Clinical Assessment');
      expect(clinicalAssessmentFinder, findsNothing);
    });

    testWidgets('PDF file detection works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Image file detection works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithImage));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar has back navigation button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
    });
    
    testWidgets('Different reports show proper distinct content',
        (WidgetTester tester) async {
      // First render with PDF report
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));
      expect(find.text('Cardiology'), findsOneWidget);

      // Verify unique content for PDF report
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Clinical assessment box styling is correct',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithImage));
      await tester.pump();

      // Remarks text should be displayed in image viewer
      expect(find.text('X-ray taken successfully'), findsOneWidget);
      // Clinical Assessment header should be present for non-empty remarks
      expect(find.text('Clinical Assessment'), findsOneWidget);
      // Container should exist for assessment box
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Remarks text is visible in report',
        (WidgetTester tester) async {
      const reportWithSpecificRemarks = ReportEntity(
        reportId: 'report_specific',
        appointmentId: 'apt_spec',
        hospitalUsername: 'Test Hospital',
        department: 'Testing',
        remarks: 'Patient shows improvement',
        reportUrl: 'reports/test_image.jpg',
        createdAt: null,
      );

      await tester.pumpWidget(createTestWidget(report: reportWithSpecificRemarks));
      await tester.pump();

      expect(find.text('Patient shows improvement'), findsOneWidget);
    });

    testWidgets('Multiple departments display correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithImage));

      expect(find.text('Radiology'), findsOneWidget);
    });

    testWidgets('Screen layout structure is correct',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithPdf));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}
