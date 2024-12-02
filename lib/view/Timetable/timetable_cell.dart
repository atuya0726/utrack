import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/Class/class_page.dart';
import 'package:utrack/view/Task/task_page.dart';

class TimetableCell extends StatelessWidget {
  const TimetableCell({
    super.key,
    required this.cls,
    required this.dayOfWeek,
    required this.period,
  });

  final ClassModel? cls;
  final Week dayOfWeek;
  final Period period;

  @override
  Widget build(BuildContext context) {
    if (cls == null) {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (BuildContext context, _) {
          return Card(
            color: Theme.of(context).colorScheme.surface,
            elevation: 0.25,
            margin: const EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const SizedBox(
              height: 100,
            ),
          );
        },
        openBuilder: (BuildContext context, _) {
          return ClassPage(dayOfWeek: dayOfWeek, period: period);
        },
      );
    } else {
      return OpenContainer(
        closedElevation: 0.0,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (BuildContext context, _) {
          return _buildClosedTimeTableCell(context, cls!);
        },
        openBuilder: (BuildContext context, _) {
          return TaskPage(
            classId: cls!.id,
            period: period,
            dayOfWeek: dayOfWeek,
          );
        },
      );
    }
  }

  Card _buildClosedTimeTableCell(BuildContext context, ClassModel cls) {
    return Card(
      color: Theme.of(context).colorScheme.primaryFixed,
      margin: const EdgeInsets.all(1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 縦方向で中央に配置
            crossAxisAlignment: CrossAxisAlignment.center, // 横方向で中央に配置
            children: [
              Text(
                cls.name,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    cls.place,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
