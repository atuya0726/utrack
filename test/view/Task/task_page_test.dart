import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/view/Task/task_page.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/viewmodel/timetable.dart';

import '../../mock/firebase_mock.dart';
import '../../mock/notifier.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  const classId = 'test_class';
  final testClass = ClassModel(
    id: classId,
    name: 'Test Class',
    professor: 'Test Professor',
    dayOfWeek: Week.mon,
    period: [Period.first],
    place: 'Test Room',
    semester: '1',
    grade: [1],
    users: [],
  );

  Widget createWidget(mockTaskNotifier, mockTimetableNotifier) {
    return ProviderScope(
      overrides: [
        taskProvider.overrideWith((ref) => mockTaskNotifier),
        timetableProvider.overrideWith((ref) => mockTimetableNotifier),
      ],
      child: MaterialApp(
        home: TaskPage(cls: testClass),
      ),
    );
  }

  testWidgets('タスクページの基本的なUIが正しく表示される', (WidgetTester tester) async {
    final mockTaskNotifier = MockTaskNotifier();
    final mockTimetableNotifier = MockTimetableNotifier();
    await tester
        .pumpWidget(createWidget(mockTaskNotifier, mockTimetableNotifier));
    await tester.pumpAndSettle();

    // Assert
    // AppBarの確認
    expect(find.text('Task List'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // AddTaskとListTaskの存在確認
    expect(find.byType(AddTask), findsOneWidget);
    expect(find.byType(ListTask), findsOneWidget);

    // 各ウィジェットに正しい引数が渡されているか確認
    final addTaskWidget = tester.widget<AddTask>(find.byType(AddTask));
    expect(addTaskWidget.cls.id, classId);
    expect(addTaskWidget.cls.period.first, Period.first);
    expect(addTaskWidget.cls.dayOfWeek, Week.mon);

    final listTaskWidget = tester.widget<ListTask>(find.byType(ListTask));
    expect(listTaskWidget.classId, classId);
  });

  testWidgets('削除ボタンを押すと確認ダイアログが表示され、削除が実行される', (WidgetTester tester) async {
    // Arrange
    final mockTaskNotifier = MockTaskNotifier();
    final mockTimetableNotifier = MockTimetableNotifier();
    await tester
        .pumpWidget(createWidget(mockTaskNotifier, mockTimetableNotifier));
    await tester.pumpAndSettle();

    // Act - 削除ボタンをタップ
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // 確認ダイアログが表示されることを確認
    expect(find.text('授業の削除'), findsOneWidget);
    expect(find.text('${testClass.name}を削除してよろしいですか？\n関連する課題も全て削除されます。'),
        findsOneWidget);

    // 削除を実行
    await tester.tap(find.text('削除'));
    await tester.pumpAndSettle();

    verify(mockTaskNotifier.deleteTask(
      taskId: '123',
    )).called(1);
    verify(mockTimetableNotifier.deleteTimetable(
      cls: testClass,
    )).called(1);

    // Assert - ダイアログが閉じられ、前の画面に戻ることを確認
    expect(find.byType(TaskPage), findsNothing);
  });

  testWidgets('削除確認ダイアログでキャンセルを選択すると削除されない', (WidgetTester tester) async {
    // Arrange
    final mockTaskNotifier = MockTaskNotifier();
    final mockTimetableNotifier = MockTimetableNotifier();
    await tester
        .pumpWidget(createWidget(mockTaskNotifier, mockTimetableNotifier));
    await tester.pumpAndSettle();

    // Act - 削除ボタンをタップ
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // 確認ダイアログが表示されることを確認
    expect(find.text('授業の削除'), findsOneWidget);
    expect(find.text('${testClass.name}を削除してよろしいですか？\n関連する課題も全て削除されます。'),
        findsOneWidget);

    // キャンセルを実行
    await tester.tap(find.text('キャンセル'));
    await tester.pumpAndSettle();

    verifyNever(mockTaskNotifier.deleteTask(
      taskId: '123',
    ));
    verifyNever(mockTimetableNotifier.deleteTimetable(
      cls: testClass,
    ));

    // Assert - ダイアログが閉じられ、画面は閉じられないことを確認
    expect(find.text('授業の削除'), findsNothing);
    expect(find.byType(TaskPage), findsOneWidget);
  });
}
