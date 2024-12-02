import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/view/Class/search_bar.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/constants.dart';

import '../notifierMock/class_mock.dart';

void main() {
  testWidgets('RealTimeSearchBar calls searchClasses on text input',
      (WidgetTester tester) async {
    // モックプロバイダーを作成
    final container = ProviderContainer(overrides: [
      classProvider.overrideWith((ref) => MockClassNotifier()),
    ]);

    addTearDown(container.dispose);

    // テスト対象ウィジェットを作成
    final widget = UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          body: RealTimeSearchBar(
            dayOfWeek: Week.mon,
            period: Period.first,
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // テキストフィールドが存在するか確認
    expect(find.byType(TextField), findsOneWidget);

    // テキストを入力
    const testInput = '数学';
    await tester.enterText(find.byType(TextField), testInput);

    // モックプロバイダーのメソッドが呼び出されたことを確認
    final mockNotifier =
        container.read(classProvider.notifier) as MockClassNotifier;
    expect(mockNotifier.isCalled, true);
    expect(mockNotifier.lastArgs, {
      'text': testInput,
      'dayOfWeek': Week.mon,
      'period': Period.first,
    });
  });
}
