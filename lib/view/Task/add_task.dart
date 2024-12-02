import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
    required this.classId,
    required this.period,
    required this.dayOfWeek,
  });
  final String classId;
  final Period period;
  final Week dayOfWeek;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  HowToSubmit _selectedSubmitMethod = HowToSubmit.online;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // 必ずdispose()でコントローラーを破棄
    _dateController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = ProviderScope.containerOf(context);
    final dateFormatter = DateFormat(dateFormat);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          children: [
            _buildAddTaskText(),
            const SizedBox(
              height: 20,
            ),
            _buildInputTaskName(),
            const SizedBox(
              height: 20,
            ),
            _buildDateSubmit(dateFormatter, ref),
            const SizedBox(
              height: 20,
            ),
            _buildChoiceHowToSubmit(),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                final ref = ProviderScope.containerOf(context);
                final taskData = {
                  'classId': widget.classId,
                  'userId': '',
                  'name': _nameController.text,
                  'deadline': dateFormatter.parse(_dateController.text),
                  'howToSubmit': _selectedSubmitMethod.name
                };
                ref.read(taskProvider.notifier).addTasks(taskData: taskData);
                _snackBar();
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildChoiceHowToSubmit() {
    return Row(
      children: [
        Text(
          '提出方法',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: HowToSubmit.values.map((howToSubmit) {
            return FilterChip(
              label: Text(howToSubmit.label),
              selected: _selectedSubmitMethod == howToSubmit,
              onSelected: (isSelected) {
                setState(() {
                  _selectedSubmitMethod = howToSubmit;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  TextField _buildInputTaskName() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.clear),
        labelText: '課題の名前',
        border: OutlineInputBorder(),
      ),
    );
  }

  Align _buildAddTaskText() {
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

  Column _buildDateSubmit(DateFormat dateFormatter, ProviderContainer ref) {
    final ref = ProviderScope.containerOf(context);

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 角丸の半径を指定
                  ),
                ),
                onPressed: () {
                  setState(() {
                    DateTime date = ref
                        .read(taskProvider.notifier)
                        .nextWeekAt2359(dayOfWeek: widget.dayOfWeek);
                    _dateController.text = dateFormatter.format(date);
                  });
                },
                child: const Text(
                  '来週23:59に設定',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 角丸の半径を指定
                  ),
                ),
                onPressed: () {
                  DateTime date = ref
                      .read(taskProvider.notifier)
                      .nextWeekClassStartTime(
                          dayOfWeek: widget.dayOfWeek, period: widget.period);
                  _dateController.text = dateFormatter.format(date);
                },
                child: const Text(
                  '来週授業開始前に設定',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 1,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 角丸の半径を指定
                  ),
                ),
                onPressed: () {
                  picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    onChanged: (datetime) =>
                        _dateController.text = dateFormatter.format(datetime),
                    locale: picker.LocaleType.jp,
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text(
                  '自由に設定',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          readOnly: true,
          controller: _dateController,
          decoration: const InputDecoration(
            labelText: '提出日',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  _snackBar() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('追加完了'),
      ),
    );
  }
}
