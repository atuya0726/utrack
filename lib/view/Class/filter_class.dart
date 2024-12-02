import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/class.dart';

class SelectFilter extends StatefulWidget {
  const SelectFilter(
      {super.key, required this.dayOfWeek, required this.period});
  final Week dayOfWeek;
  final Period period;

  @override
  State<SelectFilter> createState() => SelectFilterState();
}

class SelectFilterState extends State<SelectFilter> {
  Grade? selectedGrade;
  @override
  Widget build(BuildContext context) {
    final ref = ProviderScope.containerOf(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '学年',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: Grade.values.map((grade) {
                  return FilterChip(
                    label: Text(grade.label),
                    selected: selectedGrade == grade,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedGrade = isSelected ? grade : null;
                        ref.read(classProvider.notifier).filterClasses(
                              grade: selectedGrade,
                              period: widget.period,
                              dayOfWeek: widget.dayOfWeek,
                            );
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
