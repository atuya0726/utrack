import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/view/Class/filter_class.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/constants.dart';

import '../../notifierMock/class_mock.dart';

void main() {
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

    // 初期状態を確認（FilterChipが存在し、未選択状態であること）
    expect(find.text('学年'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(Grade.values.length));
    for (var grade in Grade.values) {
      final chip = find.widgetWithText(FilterChip, grade.label);
      expect(chip, findsOneWidget);
      final FilterChip filterChip = tester.widget(chip);
      expect(filterChip.selected, false);
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
    expect(mockNotifier.isCalled, true);
    expect(mockNotifier.lastArgs, {
      'grade': Grade.values.first,
      'period': Period.first,
      'dayOfWeek': Week.mon,
    });
  });
}
