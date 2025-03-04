import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class AddTask extends StatefulWidget {
  const AddTask({
    super.key,
    required this.cls,
  });
  final ClassModel cls;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  HowToSubmit? _selectedSubmitMethod;
  TaskType? _selectedTaskType;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
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
            _buildMemo(),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () {
                if (_selectedTaskType == null ||
                    _selectedSubmitMethod == null ||
                    _dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('全ての項目を入力してください'),
                    ),
                  );
                  return;
                }

                final ref = ProviderScope.containerOf(context);
                ref.read(taskProvider.notifier).addTask(
                      classId: widget.cls.id,
                      name: _selectedTaskType!.label,
                      deadline: dateFormatter.parse(_dateController.text),
                      howToSubmit: _selectedSubmitMethod!,
                      memo: _memoController.text,
                    );
                setState(() {
                  _selectedTaskType = null;
                  _selectedSubmitMethod = null;
                });
                _memoController.clear();
                _dateController.clear();
                _snackBar();
              },
              child: const Text('追加'),
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
                  _selectedSubmitMethod = isSelected ? howToSubmit : null;
                });
              },
            );
          }).toList(),
        ),
      ],
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

  Widget _buildInputTaskName() {
    return DropdownButtonFormField<TaskType>(
      key: const Key('taskTypeDropdown'),
      value: _selectedTaskType,
      decoration: const InputDecoration(
        labelText: '課題の種類',
        border: OutlineInputBorder(),
      ),
      items: TaskType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.label),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTaskType = value;
        });
      },
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
                        .nextWeekAt2359(dayOfWeek: widget.cls.dayOfWeek);
                    _dateController.text = dateFormatter.format(date);
                  });
                },
                child: const Text(
                  '来週の授業前日23:59',
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
                          dayOfWeek: widget.cls.dayOfWeek,
                          period: widget.cls.period.first);
                  _dateController.text = dateFormatter.format(date);
                },
                child: const Text(
                  '来週の授業開始前',
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
                    minTime: clock.now(),
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

  Widget _buildMemo() {
    return TextField(
      controller: _memoController,
      readOnly: true,
      maxLength: 30,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _memoController,
                  maxLength: 30,
                  autofocus: true,
                  onEditingComplete: () =>
                      Navigator.pop(context), // Enterキーで閉じる
                  onTapOutside: (_) => Navigator.pop(context), // フォーカスが外れたら閉じる
                  decoration: const InputDecoration(
                    labelText: '一言メモ（30文字以内）',
                  ),
                ),
              ),
            );
          },
        );
      },
      decoration: const InputDecoration(
        labelText: '一言メモ（30文字以内）',
      ),
    );
  }

  _snackBar() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('追加完了'),
      ),
    );
  }
}
