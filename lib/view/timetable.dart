import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/constants.dart';
import 'package:utrack/view/list_classes.dart';
import 'package:utrack/view/list_task.dart';
import 'package:utrack/view/mock_variables.dart';

class Timetable extends StatelessWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
      child: Table(
        // border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(0.3), // 曜日の列
          1: FlexColumnWidth(1), // 各時限の列
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        children: [
          _buildHeaderRow(), // ヘッダー行（曜日と時限）
          ..._buildTimetableRows(), // 時間割データを行に変換
        ],
      ),
    );
  }

  // ヘッダー行（曜日と時限）の作成
  // ヘッダー行（曜日）の作成
  TableRow _buildHeaderRow() {
    List<TableCell> tableCells = [
      const TableCell(
        child: Center(
          child: Spacer(),
        ),
      ),
    ];

    for (var day in week) {
      tableCells.add(
        TableCell(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    return TableRow(children: tableCells);
  }

  // 時限ごとのデータ行を作成
  List<TableRow> _buildTimetableRows() {
    List<TableRow> rows = [];

    // 各時限ごとに行を作成
    for (int period = 1; period <= timetable.length; period++) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Center(
                child: Text(
                  '$period',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TimetableCell(cls: timetable['mon']?[period]),
            TimetableCell(cls: timetable['tue']?[period]),
            TimetableCell(cls: timetable['wed']?[period]),
            TimetableCell(cls: timetable['thu']?[period]),
            TimetableCell(cls: timetable['fri']?[period]),
          ],
        ),
      );
    }

    return rows;
  }
}

class TimetableCell extends StatelessWidget {
  const TimetableCell({super.key, this.cls});

  final ClassModel? cls;

  @override
  Widget build(BuildContext context) {
    if (cls == null) {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (BuildContext context, _) {
          return Card(
            color: Theme.of(context).colorScheme.surface,
            elevation: 0.25,
            margin: const EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const SizedBox(
              height: 100,
            ),
          );
        },
        openBuilder: (BuildContext context, _) {
          return const ClassesList();
        },
      );
    } else {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (BuildContext context, _) {
          return _buildClosedTimeTableCell(context);
        },
        openBuilder: (BuildContext context, _) {
          return TasksList();
        },
      );
    }
  }

  Card _buildClosedTimeTableCell(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryFixed,
      margin: const EdgeInsets.all(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 縦方向で中央に配置
            crossAxisAlignment: CrossAxisAlignment.center, // 横方向で中央に配置
            children: [
              Text(
                cls!.name,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    cls!.place,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum HowToSubmit {
  online('オンライン'),
  offline('手渡し');

  const HowToSubmit(this.label);
  final String label;
}

class TasksList extends StatelessWidget {
  TasksList({super.key});
  final TextEditingController controller =
      TextEditingController(text: '2024-10-23');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text('Task List'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  children: [
                    _buildAddTaskText(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildInputTaskName(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildChoiceHowToSubmit(context),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildDateSubmit(context),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      onPressed: () => _snackBar(context),
                      child: Text('追加'),
                    ),
                  ],
                ),
              ),
            ),
            ListTask(),
          ],
        ),
      ),
    );
  }

  Column _buildDateSubmit(BuildContext context) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          controller: controller,
          decoration: const InputDecoration(
            labelText: '提出日',
            suffixIcon: Icon(Icons.calendar_month),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () => 'todo',
              child: const Text(
                '来週23:59\nに設定',
                textAlign: TextAlign.center,
              ),
            ),
            OutlinedButton(
              onPressed: () => 'todo',
              child: const Text(
                '来週授業開始前\nに設定',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _buildChoiceHowToSubmit(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownMenu(
        hintText: '提出方法',
        initialSelection: HowToSubmit.online,
        dropdownMenuEntries:
            HowToSubmit.values.map<DropdownMenuEntry<HowToSubmit>>(
          (HowToSubmit howToSubmit) {
            return DropdownMenuEntry<HowToSubmit>(
              value: howToSubmit,
              label: howToSubmit.label,
            );
          },
        ).toList(),
      ),
    );
  }

  TextField _buildInputTaskName(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.clear),
        labelText: '課題の名前',
        border: OutlineInputBorder(),
      ),
    );
  }

  Align _buildAddTaskText(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '課題の追加',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _snackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('追加完了'),
      ),
    );
  }
}
