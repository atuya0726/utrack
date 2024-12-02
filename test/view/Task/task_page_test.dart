import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/view/Task/task_page.dart';

void main() {
  testWidgets('TasksList renders correctly and passes correct arguments',
      (WidgetTester tester) async {
    // Arrange
    const classId = 'test_class';
    const period = Period.first;
    const dayOfWeek = Week.mon;

    // Act
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TaskPage(
            classId: classId,
            dayOfWeek: dayOfWeek,
            period: period,
          ),
        ),
      ),
    );

    // Assert
    // AppBarのタイトル確認
    expect(find.text('Task List'), findsOneWidget);

    // AddTaskウィジェットの存在と引数確認
    final addTaskWidget = tester.widget<AddTask>(find.byType(AddTask));
    expect(addTaskWidget.classId, classId);
    expect(addTaskWidget.period, period);
    expect(addTaskWidget.dayOfWeek, dayOfWeek);

    // ListTaskウィジェットの存在と引数確認
    final listTaskWidget = tester.widget<ListTask>(find.byType(ListTask));
    expect(listTaskWidget.classId, classId);
  });
}
