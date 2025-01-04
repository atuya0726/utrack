import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Timetable/timetable_cell.dart';

void main() {
  Widget createWidget(classModel) {
    return MaterialApp(
      home: Scaffold(
        body: TimetableCell(
          cls: classModel,
          dayOfWeek: Week.mon,
          period: Period.first,
        ),
      ),
    );
  }

  group('時間割セルのテスト', () {
    testWidgets('授業が設定されていない場合の表示テスト', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget(null));

      // 空のカードが表示されることを確認
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Text), findsNothing);

      // カードの高さが100であることを確認
      final SizedBox sizedBox = tester.widget(find.byType(SizedBox));
      expect(sizedBox.height, 100.0);
    });

    testWidgets('授業が設定されている場合の表示テスト', (WidgetTester tester) async {
      final classModel = ClassModel(
        id: "test-id",
        name: "プログラミング基礎",
        professor: "山田太郎",
        place: "情報棟201",
        period: [Period.first],
        dayOfWeek: Week.mon,
        semester: "前期",
        grade: [1],
        users: [],
      );

      await tester.pumpWidget(createWidget(classModel));

      // 授業名と教室が表示されることを確認
      expect(find.text('プログラミング基礎'), findsOneWidget);
      expect(find.text('情報棟201'), findsOneWidget);

      // カードの色が設定されていることを確認
      final Card card = tester.widget(find.byType(Card).first);
      expect(card.color, isNotNull);
    });

    testWidgets('テキストオーバーフローの処理テスト', (WidgetTester tester) async {
      final classModel = ClassModel(
        id: "test-id",
        name: "とても長い授業名のプログラミング基礎演習実践応用発展講座",
        professor: "山田太郎",
        place: "とても長い教室名の情報教育研究実践センター第一実習室",
        period: [Period.first],
        dayOfWeek: Week.mon,
        semester: "前期",
        grade: [1],
        users: [],
      );

      await tester.pumpWidget(createWidget(classModel));

      // テキストが表示されていることを確認
      expect(find.byType(Text), findsNWidgets(2));

      // オーバーフローが発生していても例外が発生しないことを確認
      expect(() => tester.pumpAndSettle(), returnsNormally);
    });
  });
}
