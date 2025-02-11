import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/model/constants.dart';

class ListTask extends ConsumerStatefulWidget {
  final String? classId;
  const ListTask({super.key, required this.classId});

  @override
  ConsumerState<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends ConsumerState<ListTask> {
  TaskStatus _selectedStatus = TaskStatus.inProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(taskProvider.notifier)
          .filterTasks(classId: widget.classId, status: TaskStatus.inProgress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);
    if (ref.watch(taskProvider.notifier).noTask()) {
      return const Expanded(
        child: Center(
          child: Text('タスクがありません'),
        ),
      );
    }
    return Expanded(
      child: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return _buildListTile(context, taskList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: TaskStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                selected: _selectedStatus == status,
                label: Text(status.label),
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? status : TaskStatus.inProgress;
                    ref.read(taskProvider.notifier).filterTasks(
                        classId: widget.classId, status: _selectedStatus);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, TaskModel task) {
    return ListTile(
      leading: Icon(Icons.access_alarm,
          color: ref
              .read(taskProvider.notifier)
              .getColor(task.deadline, task.status)),
      title: FutureBuilder<String>(
        future:
            ref.read(classProvider.notifier).getNameById(classId: task.classId),
        builder: (context, snapshot) {
          final className = snapshot.data ?? '';
          return Text(
            '$className: ${task.name}',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          );
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ref
              .read(taskProvider.notifier)
              .calcRemainingDays(datetime: task.deadline)),
          Text(task.memo ?? ''),
        ],
      ),
      tileColor: Theme.of(context).colorScheme.surface,
      trailing: IconButton(
        onPressed: () {
          _showCompleteDialog(context, task);
        },
        icon: const Icon(Icons.more_vert),
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('タスクのステータスを\n変更します'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDeleteButton(context, task),
                Row(
                  children: _buildButtons(context, task),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildButtons(BuildContext context, TaskModel task) {
    if (_selectedStatus == TaskStatus.completed) {
      return [
        _buildInProgressButton(context, task),
      ];
    } else if (_selectedStatus == TaskStatus.inProgress) {
      return [
        _buildGiveUpButton(context, task),
        _buildCompleteButton(context, task),
      ];
    } else if (_selectedStatus == TaskStatus.canceled) {
      return [
        _buildInProgressButton(context, task),
        _buildCompleteButton(context, task),
      ];
    } else {
      return [
        _buildCompleteButton(context, task),
      ];
    }
  }

  TextButton _buildInProgressButton(BuildContext context, TaskModel task) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        ref.read(taskProvider.notifier).updateTaskStatus(
              taskId: task.id,
              status: TaskStatus.inProgress,
            );
      },
      child: const Text('進行中'),
    );
  }

  TextButton _buildDeleteButton(BuildContext context, TaskModel task) {
    return TextButton(
      onPressed: () {
        ref.read(taskProvider.notifier).deleteTask(
              taskId: task.id,
            );
        Navigator.pop(context);
        _snackBar(context);
      },
      child: const Text(
        '削除',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  TextButton _buildGiveUpButton(BuildContext context, TaskModel task) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        ref.read(taskProvider.notifier).updateTaskStatus(
              taskId: task.id,
              status: TaskStatus.canceled,
            );
      },
      child: const Text('諦めた'),
    );
  }

  TextButton _buildCompleteButton(BuildContext context, TaskModel task) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        ref.read(taskProvider.notifier).updateTaskStatus(
              taskId: task.id,
              status: TaskStatus.completed,
            );
        ref.read(taskProvider.notifier).filterTasks(
            classId: widget.classId, status: TaskStatus.inProgress);
      },
      child: const Text('完了'),
    );
  }

  _snackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('削除完了'),
      ),
    );
  }
}
