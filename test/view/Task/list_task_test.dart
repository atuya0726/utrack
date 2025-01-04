import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/viewmodel/task.dart';

import '../../mock/firebase_mock.dart';
import '../../mock/mock_variables.dart';
import '../../mock/notifier.mocks.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  Widget createWidget(mockNotifier) {
    return ProviderScope(
      overrides: [
        taskProvider.overrideWith((ref) => mockNotifier),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTask(classId: 'test'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('基本的なUIコンポーネントが表示される', (WidgetTester tester) async {
    final mockNotifier = MockTaskNotifier();
    when(mockNotifier.state).thenReturn(mockTasks);

    await tester.pumpWidget(createWidget(mockNotifier));
    await tester.pumpAndSettle();

    // フィルターチップの確認
    expect(find.byType(FilterChip), findsNWidgets(TaskStatus.values.length));
    expect(find.text(TaskStatus.inProgress.label), findsOneWidget);
    expect(find.text(TaskStatus.completed.label), findsOneWidget);
    expect(find.text(TaskStatus.canceled.label), findsOneWidget);
  });

  // testWidgets('タスクのステータスフィルタリングが機能する', (WidgetTester tester) async {
  //   final mockNotifier = MockTaskNotifier();
  //   mockNotifier.state = mockTasks;
  //   await tester.pumpWidget(createWidget(mockNotifier));
  //   await tester.pumpAndSettle();

  //   // 完了済みフィルターをタップ
  //   await tester.tap(find.text(TaskStatus.completed.label));
  //   await tester.pumpAndSettle();

  //   // フィルタリングが呼び出されたことを確認
  //   verify(mockNotifier.filterTasks(
  //     status: TaskStatus.completed,
  //   )).called(1);
  // });

  // testWidgets('タスクの削除が正しく動作する', (WidgetTester tester) async {
  //   final mockNotifier = MockTaskNotifier();
  //   when(mockNotifier.addListener(any, fireImmediately: true))
  //       .thenReturn(() {});
  //   mockNotifier.state = mockTasks;
  //   when(mockNotifier.deleteTask(taskId: '123')).thenAnswer((_) async {});
  //   await tester.pumpWidget(createWidget(mockNotifier));
  //   await tester.pumpAndSettle();

  //   // メニューボタンをタップ
  //   await tester.tap(find.byIcon(Icons.more_vert).first);
  //   await tester.pumpAndSettle();

  //   // 削除ボタンをタップ
  //   await tester.tap(find.text('削除'));
  //   await tester.pumpAndSettle();

  //   // 削除が呼び出されたことを確認
  //   verify(mockNotifier.deleteTask(taskId: '123')).called(1);
  //   expect(find.text('削除完了'), findsOneWidget);
  // });

  // testWidgets('タスクのステータス更新が正しく動作する', (WidgetTester tester) async {
  //   final mockNotifier = MockTaskNotifier();
  //   mockNotifier.state = mockTasks;
  //   await tester.pumpWidget(createWidget(mockNotifier));
  //   await tester.pumpAndSettle();

  //   // メニューボタンをタップ
  //   await tester.tap(find.byIcon(Icons.more_vert).first);
  //   await tester.pumpAndSettle();

  //   // 完了ボタンをタップ
  //   await tester.tap(find.text('完了').last);
  //   await tester.pumpAndSettle();

  //   // 所要時間選択ダイアログが表示されることを確認
  //   expect(find.text('タスク所要時間を選択してください'), findsOneWidget);

  //   // 1時間未満を選択
  //   await tester.tap(find.text('1時間未満'));
  //   await tester.pumpAndSettle();

  //   // ステータス更新が呼び出されたことを確認
  //   verify(mockNotifier.updateTaskStatus(
  //     taskId: '123',
  //     status: TaskStatus.completed,
  //   )).called(1);
  // });

  // testWidgets('タスクが空の場合、適切なメッセージが表示される', (WidgetTester tester) async {
  //   final mockNotifier = MockTaskNotifier();
  //   mockNotifier.setEmptyTasks();
  //   await tester.pumpWidget(createWidget(mockNotifier));
  //   await tester.pumpAndSettle();

  //   expect(find.text('タスクがありません'), findsOneWidget);
  // });
}
