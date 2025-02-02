import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/timetable.dart';
import 'package:utrack/view/Class/filter_class.dart';
import 'package:utrack/utils/logger.dart';

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
    Logger.log('ClassesList initialized', tag: 'ClassesList');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Logger.log(
            'Filtering classes for ${widget.dayOfWeek} period ${widget.period}',
            tag: 'ClassesList');
        final ref = ProviderScope.containerOf(context);
        ref.read(classProvider.notifier).filterClasses(
              grade: null,
              major: null,
              semester: null,
              dayOfWeek: widget.dayOfWeek,
              period: widget.period,
            );
      } catch (e) {
        Logger.error('Error filtering classes', error: e);
      }
    });
  }

  void _showFilterBottomSheet() {
    Logger.log('Opening filter bottom sheet', tag: 'ClassesList');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SelectFilter(
          dayOfWeek: widget.dayOfWeek,
          period: widget.period,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger.log('Building ClassesList widget', tag: 'ClassesList');
    return Expanded(
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final classes = ref.watch(classProvider);
              return ListView.builder(
                itemCount: classes.length * 2,
                itemBuilder: (context, index) {
                  if (index.isEven) {
                    return __buildListTile(context, classes[index ~/ 2], ref);
                  } else {
                    return const Divider(height: 0);
                  }
                },
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _showFilterBottomSheet,
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
    );
  }

  ListTile __buildListTile(
      BuildContext context, ClassModel cls, WidgetRef ref) {
    Logger.log('Building list tile for class: ${cls.name}', tag: 'ClassesList');
    return ListTile(
      title: Text(
        cls.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(cls.professor),
      tileColor: Theme.of(context).colorScheme.surface,
      trailing: IconButton(
        onPressed: () {
          Logger.log('Adding class to timetable: ${cls.name}',
              tag: 'ClassesList');
          ref.read(timetableProvider.notifier).addTimetable(cls: cls);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
