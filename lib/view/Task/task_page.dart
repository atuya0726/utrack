import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/viewmodel/task.dart';
import 'package:utrack/viewmodel/timetable.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({
    super.key,
    required this.cls,
  });
  final ClassModel cls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text('Task List'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context, cls, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          AddTask(cls: cls),
          ListTask(classId: cls.id),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    ClassModel cls,
    WidgetRef ref,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('授業の削除'),
          content: Text('${cls.name}を削除してよろしいですか？\n関連する課題も全て削除されます。'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('削除'),
              onPressed: () async {
                await ref
                    .read(timetableProvider.notifier)
                    .deleteTimetable(cls: cls);
                if (context.mounted) {
                  ref.invalidate(taskProvider);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
