import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/viewmodel/class.dart';

import '../../notifierMock/class_mock.dart';
import '../../notifierMock/task_mock.dart';

void main() {
  testWidgets('ListTask renders tasks and allows deletion',
      (WidgetTester tester) async {
    // モックプロバイダーを作成
    final mockTaskNotifier = MockTaskNotifier();
    final mockClassNotifier = MockClassNotifier();
    final container = ProviderContainer(overrides: [
      taskProvider.overrideWith((ref) => mockTaskNotifier),
      classProvider.overrideWith((ref) => mockClassNotifier),
    ]);
    addTearDown(container.dispose);

    // テスト対象ウィジェットを作成
    final widget = UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          body: ListTask(classId: 'class'),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // タスク一覧が正しくレンダリングされるか確認
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('class: レポート'), findsOneWidget);
    expect(find.text('class: 期末レポート'), findsOneWidget);

    // 削除ボタンをタップ
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pumpAndSettle();

    // deleteTaskが正しく呼び出されたか確認
    expect(mockTaskNotifier.isCalled, true);
    expect(mockTaskNotifier.lastDeletedTask, {'id': '123', 'classId': 'test'});

    // スナックバーが表示されることを確認
    expect(find.text('削除完了'), findsOneWidget);
  });
}
