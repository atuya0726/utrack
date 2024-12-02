import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/constants.dart';

import '../../notifierMock/task_mock.dart';

void main() {
  testWidgets('AddTask allows task creation and updates state',
      (WidgetTester tester) async {
    // モックプロバイダーを作成
    final mockNotifier = MockTaskNotifier();
    final container = ProviderContainer(overrides: [
      taskProvider.overrideWith((ref) => mockNotifier),
    ]);

    addTearDown(container.dispose);

    // テスト対象ウィジェットを作成
    final widget = UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          body: AddTask(
            classId: 'class1',
            period: Period.first,
            dayOfWeek: Week.mon,
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // 初期状態を確認
    expect(find.text('課題の追加'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // 課題名と提出日
    expect(find.byType(OutlinedButton), findsNWidgets(3)); // 日付ボタン3つ

    // 課題名を入力
    const taskName = 'Test Task';
    await tester.enterText(find.widgetWithText(TextField, '課題の名前'), taskName);

    // 日付設定ボタンを押す
    await tester.tap(find.widgetWithText(OutlinedButton, '来週23:59に設定'));
    await tester.pumpAndSettle();

    // モックデータの日付が設定されているか確認
    final TextField textField =
        tester.widget<TextField>(find.widgetWithText(TextField, '提出日'));
    final TextEditingController dateController = textField.controller!;
    expect(dateController.text, mockNotifier.mockNextWeekAt2359);

    // 提出方法を変更
    await tester.tap(find.text('オンライン'));
    await tester.pumpAndSettle();

    // 「追加」ボタンを押す
    await tester.tap(find.widgetWithText(OutlinedButton, '追加'));
    await tester.pumpAndSettle();

    // モックNotifierでaddTasksが呼び出されたことを確認
    expect(mockNotifier.isCalled, true);
    expect(mockNotifier.lastTaskData, containsPair('name', taskName));
  });
}
