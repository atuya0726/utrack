import 'package:clock/clock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/constants.dart';

import '../../mock/firebase_mock.dart';
import '../../mock/notifier.mocks.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  final mockClass = ClassModel(
    id: 'class1',
    name: 'Test Class',
    professor: 'Test Professor',
    dayOfWeek: Week.mon,
    period: [Period.first],
    place: 'Test Room',
    semester: '1',
    grade: [1],
    users: [],
  );

  testWidgets('AddTask ウィジェットの基本的な表示テスト', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AddTask(cls: mockClass),
          ),
        ),
      ),
    );

    // 基本的なUIコンポーネントの存在確認
    expect(find.text('課題の追加'), findsOneWidget);
    expect(find.text('課題の種類'), findsOneWidget);
    expect(find.text('提出方法'), findsOneWidget);
    expect(find.text('提出日'), findsOneWidget);
    expect(find.text('追加'), findsOneWidget);
    // 日付選択ボタンの存在確認
    expect(find.text('来週23:59に設定'), findsOneWidget);
    expect(find.text('来週授業開始前に設定'), findsOneWidget);
    expect(find.text('自由に設定'), findsOneWidget);
    // 提出方法のチップ
    expect(find.text('オンライン'), findsOneWidget);
    expect(find.text('手渡し'), findsOneWidget);
    expect(find.text('投函'), findsOneWidget);
  });

  testWidgets('選択テスト', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AddTask(cls: mockClass),
          ),
        ),
      ),
    );

    // 提出方法のチップをタップ
    await tester.tap(find.text('オンライン'));
    await tester.pump();
    // 選択状態の確認
    final filterChipOnline = tester.widget<FilterChip>(
      find.byType(FilterChip).at(0),
    );
    expect(filterChipOnline.selected, isTrue);

    await tester.tap(find.text('手渡し'));
    await tester.pump();
    // 選択状態の確認
    final filterChipHandover = tester.widget<FilterChip>(
      find.byType(FilterChip).at(1),
    );
    expect(filterChipHandover.selected, isTrue);

    await tester.tap(find.text('投函'));
    await tester.pump();
    // 選択状態の確認
    final filterChipMail = tester.widget<FilterChip>(
      find.byType(FilterChip).at(2),
    );
    expect(filterChipMail.selected, isTrue);

    await tester.tap(find.text('投函'));
    await tester.pump();
    final filterChip2 = tester.widget<FilterChip>(
      find.byType(FilterChip).at(2),
    );
    expect(filterChip2.selected, isFalse);
  });

  testWidgets('必須項目が未入力の場合のエラーメッセージテスト', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AddTask(cls: mockClass),
          ),
        ),
      ),
    );

    // 追加ボタンをタップ
    await tester.tap(find.text('追加'));
    await tester.pump();

    // エラーメッセージの確認
    expect(find.text('全ての項目を入力してください'), findsOneWidget);
  });

  testWidgets('追加のテスト', (WidgetTester tester) async {
    await withClock(Clock.fixed(DateTime(2024, 11, 24)), () async {
      final mockNotifier = MockTaskNotifier();

      // 必要最小限のスタブのみ設定
      when(mockNotifier.nextWeekAt2359(dayOfWeek: Week.mon))
          .thenReturn(DateTime(2024, 11, 31));
      when(mockNotifier.state).thenReturn([]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskProvider.overrideWith((ref) => mockNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AddTask(cls: mockClass),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // 課題の種類を選択
      await tester.tap(find.byKey(const Key('taskTypeDropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('レポート').last);
      await tester.pumpAndSettle();

      // 提出日を設定
      await tester.tap(find.text('来週23:59に設定'));
      await tester.pump();

      // 提出方法を選択
      await tester.tap(find.text('オンライン'));
      await tester.pump();

      // 追加ボタンをタップ
      await tester.tap(find.text('追加'));
      await tester.pump();

      verify(mockNotifier.addTask(
        classId: mockClass.id,
        name: 'レポート',
        deadline: DateTime(2024, 11, 31),
        howToSubmit: HowToSubmit.online,
      )).called(1);

      // スナックバーの表示を確認
      expect(find.text('追加完了'), findsOneWidget);

      // フォームがリセットされていることを確認
      expect(find.text('課題の種類'), findsOneWidget);
      expect(find.text('提出日'), findsOneWidget);
    });
  });
}
