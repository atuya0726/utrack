import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/task.dart';

class ListTask extends ConsumerWidget {
  final String classId;
  const ListTask({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(taskProvider);
    final taskList = classId.isEmpty
        ? ref.watch(taskProvider.notifier).allTasks()
        : ref.watch(taskProvider.notifier).tasksByClassId(classId: classId);

    return Expanded(
      child: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, taskList[index], ref);
        },
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, TaskModel task, WidgetRef ref) {
    final clsRef = ProviderScope.containerOf(context);
    final clsName =
        clsRef.read(classProvider.notifier).getNameById(classId: task.classId);
    return ListTile(
      leading: const Icon(Icons.access_alarm),
      title: Text(
        '$clsName: ${task.name}',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(ref
          .read(taskProvider.notifier)
          .calcRemainingDays(datetime: task.deadline)),
      tileColor: Theme.of(context).colorScheme.surface,
      trailing: IconButton(
        onPressed: () {
          ref
              .watch(taskProvider.notifier)
              .deleteTask(id: task.id, classId: task.classId);
          _snackBar(context);
        },
        icon: const Icon(Icons.delete),
      ),
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
