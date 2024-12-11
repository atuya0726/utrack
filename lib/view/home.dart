import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utrack/view/Task/list_task.dart';
import 'package:utrack/view/Timetable/timetable.dart';
import 'package:utrack/view/drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final title = "utrack";
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      drawer: CustomDrawer(userEmail: user?.uid),
      body: Column(
        children: [
          Timetable(user: user),
          ListTask(
            classId: null,
          ),
        ],
      ),
    );
  }
}
