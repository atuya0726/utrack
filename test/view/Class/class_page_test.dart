import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/view/Class/class_page.dart';
import 'package:utrack/view/Class/filter_class.dart';
import 'package:utrack/view/Class/list_classes.dart';
import 'package:utrack/view/Class/search_bar.dart';

void main() {
  testWidgets('ClassPage should render all components correctly',
      (WidgetTester tester) async {
    // テスト用のパラメータを設定
    const dayOfWeek = Week.mon;
    const period = Period.first;

    // ウィジェットをビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ClassPage(
            dayOfWeek: dayOfWeek,
            period: period,
          ),
        ),
      ),
    );

    // 主要なコンポーネントが存在することを確認
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(RealTimeSearchBar), findsOneWidget);
    expect(find.byType(SelectFilter), findsOneWidget);
    expect(find.byType(ClassesList), findsOneWidget);

    // 正しいパラメータが渡されていることを確認
    final searchBar = tester.widget<RealTimeSearchBar>(
      find.byType(RealTimeSearchBar),
    );
    expect(searchBar.dayOfWeek, dayOfWeek);
    expect(searchBar.period, period);

    final filter = tester.widget<SelectFilter>(
      find.byType(SelectFilter),
    );
    expect(filter.dayOfWeek, dayOfWeek);
    expect(filter.period, period);

    final classList = tester.widget<ClassesList>(
      find.byType(ClassesList),
    );
    expect(classList.dayOfWeek, dayOfWeek);
    expect(classList.period, period);
  });
}