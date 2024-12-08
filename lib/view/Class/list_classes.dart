import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/timetable.dart';

class ClassesList extends StatefulWidget {
  const ClassesList({super.key, required this.dayOfWeek, required this.period});

  final Week dayOfWeek;
  final Period period;

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ref = ProviderScope.containerOf(context);
      ref.read(classProvider.notifier).filterClasses(
            grade: null,
            dayOfWeek: widget.dayOfWeek,
            period: widget.period,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final classes = ref.watch(classProvider);

        return Expanded(
          child: ListView.builder(
            itemCount: classes.length * 2,
            itemBuilder: (context, index) {
              if (index.isEven) {
                return __buildListTile(context, classes[index ~/ 2], ref);
              } else {
                return const Divider(height: 0);
              }
            },
          ),
        );
      },
    );
  }

  ListTile __buildListTile(
      BuildContext context, ClassModel cls, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.access_alarm),
      title: Text(
        cls.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(cls.professor),
      tileColor: Theme.of(context).colorScheme.surface,
      trailing: IconButton(
        onPressed: () {
          ref.read(timetableProvider.notifier).addTimetable(cls: cls);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
