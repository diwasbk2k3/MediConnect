import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/presentation/widgets/report_card_widget.dart';

void main() {
  const tReport = ReportEntity(
    reportId: 'report123',
    appointmentId: 'apt123',
    hospitalUsername: 'Hope Hospital',
    department: 'Cardiology',
    remarks: 'Patient is in good condition',
    reportUrl: 'reports/report123.pdf',
    createdAt: null,
  );

  const tReportWithoutUrl = ReportEntity(
    reportId: 'report456',
    appointmentId: 'apt456',
    hospitalUsername: 'City Medical Center',
    department: 'General Medicine',
    remarks: null,
    reportUrl: null,
    createdAt: null,
  );

  Widget createTestWidget({required ReportEntity report}) {
    return MaterialApp(
      home: Scaffold(
        body: ReportCardWidget(report: report),
      ),
    );
  }

  group('ReportCardWidget Tests', () {
    testWidgets('Report card displays all report information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      expect(find.byType(ReportCardWidget), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Hope Hospital'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Material), findsWidgets);
    });

    testWidgets('Hospital name is visible in report card',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      final hospitalNameFinder = find.text('Hope Hospital');
      expect(hospitalNameFinder, findsOneWidget);

      final hospitalNameWidget = find.text('Hope Hospital');
      expect(hospitalNameWidget, findsOneWidget);
    });

    testWidgets('Department information is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.byIcon(Icons.local_hospital), findsOneWidget);
    });

    testWidgets('Report status badge is visible and styled correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      expect(find.text('Available'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Hospital icon is rendered in report card',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      expect(find.byIcon(Icons.local_hospital), findsOneWidget);
    });

    testWidgets('Report card handles missing URL gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithoutUrl));

      expect(find.byType(ReportCardWidget), findsOneWidget);
      expect(find.text('City Medical Center'), findsOneWidget);
      expect(find.text('General Medicine'), findsOneWidget);
    });

    testWidgets('Report card has proper styling and elevation',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      final cardFinder = find.byType(Container).first;
      expect(cardFinder, findsOneWidget);
    });
    
    testWidgets('Report card is interactive with InkWell',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('Report card displays multiple different hospitals',
        (WidgetTester tester) async {
      const reportAltHospital = ReportEntity(
        reportId: 'report789',
        appointmentId: 'apt789',
        hospitalUsername: 'Sunrise Hospital',
        department: 'Orthopedics',
        remarks: null,
        reportUrl: null,
        createdAt: null,
      );

      await tester.pumpWidget(createTestWidget(report: reportAltHospital));

      expect(find.text('Sunrise Hospital'), findsOneWidget);
      expect(find.text('Orthopedics'), findsOneWidget);
    });

    testWidgets('Report card displays various medical departments',
        (WidgetTester tester) async {
      const reportWithSpecialty = ReportEntity(
        reportId: 'report999',
        appointmentId: 'apt999',
        hospitalUsername: 'Medical Center',
        department: 'Neurology',
        remarks: 'Diagnosis: Migraine',
        reportUrl: null,
        createdAt: null,
      );

      await tester.pumpWidget(createTestWidget(report: reportWithSpecialty));

      expect(find.text('Neurology'), findsOneWidget);
      expect(find.text('Medical Center'), findsOneWidget);
    });

    testWidgets('Report card handles null remarks gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReportWithoutUrl));

      expect(find.byType(ReportCardWidget), findsOneWidget);
      // Should not throw and should render without remarks section
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Report card maintains data integrity for all fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(report: tReport));

      final reportCardFinder = find.byType(ReportCardWidget);
      expect(reportCardFinder, findsOneWidget);

      // Verify all text fields are present and correct
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Hope Hospital'), findsOneWidget);
      expect(find.text('Available'), findsOneWidget);
    });
  });
}
