import 'package:flutter/material.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/view/Class/list_classes.dart';
import 'package:utrack/view/Class/filter_class.dart';
import 'package:utrack/view/Class/search_bar.dart';

class ClassPage extends StatelessWidget {
  final Week dayOfWeek;
  final Period period;
  const ClassPage({super.key, required this.dayOfWeek, required this.period});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          title: Center(
            child: RealTimeSearchBar(dayOfWeek: dayOfWeek, period: period),
          ),
        ),
        body: Column(
          children: [
            SelectFilter(dayOfWeek: dayOfWeek, period: period),
            ClassesList(dayOfWeek: dayOfWeek, period: period),
          ],
        ));
  }
}
