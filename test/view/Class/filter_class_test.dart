import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utrack/view/Class/filter_class.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/constants.dart';

import '../../mock/firebase_mock.dart';
import '../../mock/notifier.mocks.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('SelectFilter changes selected grade and calls filterClasses',
      (WidgetTester tester) async {
    final mockClassNotifier = MockClassNotifier();
    // モックプロバイダー
    final mockClassProvider = ProviderContainer(overrides: [
      classProvider.overrideWith((ref) => mockClassNotifier),
    ]);

    // テストウィジェットを作成
    final widget = ProviderScope(
      overrides: [
        classProvider.overrideWith((ref) => mockClassNotifier),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SelectFilter(
            dayOfWeek: Week.mon,
            period: Period.first,
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // すべての学年のFilterChipが表示されていることを確認
    for (var grade in Grade.values) {
      expect(find.text(grade.label), findsOneWidget);
    }

    // FilterChipをタップして選択
    final firstChip = find.widgetWithText(FilterChip, Grade.values.first.label);
    await tester.tap(firstChip);
    await tester.pumpAndSettle();

    // 選択状態が変更されたことを確認
    final FilterChip selectedChip = tester.widget(firstChip);
    expect(selectedChip.selected, true);

    // MockClassNotifierでfilterClassesが呼び出されたことを確認
    final mockNotifier =
        mockClassProvider.read(classProvider.notifier) as MockClassNotifier;
    verify(mockNotifier.filterClasses(
      grade: Grade.values.first,
      period: Period.first,
      dayOfWeek: Week.mon,
    )).called(1);

    // 同じFilterChipを再度タップして選択解除
    await tester.tap(firstChip);
    await tester.pump();
    final FilterChip unselectedChip = tester.widget(firstChip);
    expect(unselectedChip.selected, false);
  });
}
