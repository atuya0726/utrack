import 'package:flutter/material.dart';
import 'package:utrack/model/task.dart';
import 'package:utrack/view/mock_variables.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            return __buildListTile(context, tasks[index ~/ 2]);
          } else {
            return const Divider(height: 0);
          }
        },
      ),
    );
  }

  ListTile __buildListTile(BuildContext context, TaskModel task) {
    return ListTile(
      leading: const Icon(Icons.access_alarm),
      title: Text(
        task.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: const Text('結構やばめ'),
      tileColor: Theme.of(context).colorScheme.surface,
    );
  }
}
