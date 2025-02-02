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
    Logger.log(
        'ClassesList initialized with dayOfWeek: ${widget.dayOfWeek}, period: ${widget.period}',
        tag: 'ClassesList');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeClasses();
    });
  }

  Future<void> _initializeClasses() async {
    try {
      Logger.log(
          'Filtering classes - DayOfWeek: ${widget.dayOfWeek}, Period: ${widget.period}',
          tag: 'ClassesList');

      final ref = ProviderScope.containerOf(context);
      await ref.read(classProvider.notifier).filterClasses(
            grade: null,
            major: null,
            semester: null,
            dayOfWeek: widget.dayOfWeek,
            period: widget.period,
          );
      Logger.log('Classes filtered successfully', tag: 'ClassesList');
    } catch (e, stackTrace) {
      Logger.error(
        'Error filtering classes',
        error: e,
        stackTrace: stackTrace,
        tag: 'ClassesList',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('授業の読み込み中にエラーが発生しました。'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showFilterBottomSheet() {
    try {
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
    } catch (e, stackTrace) {
      Logger.error(
        'Error showing filter bottom sheet',
        error: e,
        stackTrace: stackTrace,
        tag: 'ClassesList',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('フィルターの表示中にエラーが発生しました。'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger.log('Building ClassesList widget', tag: 'ClassesList');
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            try {
              final classes = ref.watch(classProvider);
              Logger.log('Retrieved ${classes.length} classes',
                  tag: 'ClassesList');

              if (classes.isEmpty) {
                return const Center(
                  child: Text('該当する授業が見つかりませんでした。'),
                );
              }

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
            } catch (e, stackTrace) {
              Logger.error(
                'Error building class list',
                error: e,
                stackTrace: stackTrace,
                tag: 'ClassesList',
              );
              return const Center(
                child: Text('授業の表示中にエラーが発生しました。'),
              );
            }
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
    );
  }

  ListTile __buildListTile(
      BuildContext context, ClassModel cls, WidgetRef ref) {
    Logger.log('Building list tile for class: ${cls.name} (ID: ${cls.id})',
        tag: 'ClassesList');
    return ListTile(
      title: Text(
        cls.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(cls.professor),
      tileColor: Theme.of(context).colorScheme.surface,
      trailing: IconButton(
        onPressed: () async {
          try {
            Logger.log('Adding class to timetable: ${cls.name} (ID: ${cls.id})',
                tag: 'ClassesList');
            await ref.read(timetableProvider.notifier).addTimetable(cls: cls);
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${cls.name}を時間割に追加しました。'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }
          } catch (e, stackTrace) {
            Logger.error(
              'Error adding class to timetable',
              error: e,
              stackTrace: stackTrace,
              tag: 'ClassesList',
            );
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('時間割への追加中にエラーが発生しました。'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}
