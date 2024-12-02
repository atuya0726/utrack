import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Class/class_page.dart';
import 'package:utrack/view/Task/task_page.dart';
import 'package:utrack/view/Timetable/timetable_cell.dart';

void main() {
  testWidgets('TimetableCell handles cls null and non-null cases correctly',
      (WidgetTester tester) async {
    // Arrange: Set up test variables
    final classModel = ClassModel(
      id: "test",
      name: "キャリア教育基礎",
      professor: "test",
      place: "東A-404",
      period: Period.fourth,
      dayOfWeek: Week.wed,
      semester: "test",
      year: 3,
    );

    // Act 1: Render TimetableCell with cls = null
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TimetableCell(
            cls: null,
            dayOfWeek: Week.mon,
            period: Period.first,
          ),
        ),
      ),
    );

    // Assert 1: Verify UI for cls = null
    expect(find.byType(Card), findsOneWidget); // Card should be present
    expect(
        find.text('キャリア教育基礎'), findsNothing); // Class name should not be shown
    expect(find.byType(ClassPage),
        findsNothing); // ClassPage should not be shown initially

    // Act 3: Render TimetableCell with cls = classModel
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimetableCell(
            cls: classModel,
            dayOfWeek: Week.tue,
            period: Period.second,
          ),
        ),
      ),
    );

    // Assert 3: Verify UI for cls = classModel
    expect(find.text('キャリア教育基礎'),
        findsOneWidget); // Class name should be displayed
    expect(
        find.text('東A-404'), findsOneWidget); // Class place should be displayed
    expect(find.byType(TaskPage),
        findsNothing); // TaskPage should not be shown initially
  });
}
