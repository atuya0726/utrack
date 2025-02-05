import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/viewmodel/timetable.dart';
import 'package:utrack/view/Timetable/timetable_cell.dart';

class Timetable extends ConsumerWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetable = ref.watch(timetableProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
      child: SingleChildScrollView(
        child: Table(
          // border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(0.5), // 曜日の列
            1: FlexColumnWidth(1), // 各時限の列
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _buildHeaderRow(timetable), // ヘッダー行（曜日と時限）
            ..._buildTimetableRows(timetable), // 時間割データを行に変換
          ],
        ),
      ),
    );
  }

  // ヘッダー行（曜日と時限）の作成
  // ヘッダー行（曜日）の作成

  TableRow _buildHeaderRow(timetable) {
    return TableRow(
      children: [
        const SizedBox(),
        ...WeekExtension.getWeekdays().map(
          (day) => TableCell(
            child: Center(
              child: Text(
                day.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 時限ごとのデータ行を作成
  List<TableRow> _buildTimetableRows(timetable) {
    return Period.values
        .map(
          (period) => TableRow(
            children: [
              Center(
                child: Text(
                  period.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ...WeekExtension.getWeekdays().map(
                (dayOfWeek) => TimetableCell(
                  cls: timetable[dayOfWeek]?[period],
                  dayOfWeek: dayOfWeek,
                  period: period,
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
