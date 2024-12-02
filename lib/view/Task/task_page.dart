import 'package:flutter/material.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/view/Task/add_task.dart';
import 'package:utrack/view/Task/list_task.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({
    super.key,
    required this.classId,
    required this.period,
    required this.dayOfWeek,
  });
  final String classId;
  final Period period;
  final Week dayOfWeek;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text('Task List'),
        ),
      ),
      body: Column(
        children: [
          AddTask(classId: classId, period: period, dayOfWeek: dayOfWeek),
          ListTask(classId: classId),
        ],
      ),
    );
  }
}
