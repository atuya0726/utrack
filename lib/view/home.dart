import 'package:flutter/material.dart';
import 'package:utrack/view/list_task.dart';
import 'package:utrack/view/timetable.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final title = "utrack";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
      body: Column(
        children: [
          Timetable(),
          ListTask(),
        ],
      ),
    );
  }
}
