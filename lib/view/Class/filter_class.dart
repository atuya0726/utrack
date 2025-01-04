import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/viewmodel/class.dart';
import 'package:utrack/viewmodel/user_provider.dart';

class SelectFilter extends ConsumerStatefulWidget {
  const SelectFilter({
    super.key,
    required this.dayOfWeek,
    required this.period,
  });
  final Week dayOfWeek;
  final Period period;

  @override
  ConsumerState<SelectFilter> createState() => SelectFilterState();
}

class SelectFilterState extends ConsumerState<SelectFilter> {
  Grade? selectedGrade;
  Semester? selectedSemester;
  Major? selectedMajor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        setState(() {
          selectedGrade = user.grade;
          selectedMajor = user.major;
        });
      }
    });
  }

  void _applyFilter() {
    ref.read(classProvider.notifier).filterClasses(
          grade: selectedGrade,
          semester: selectedSemester,
          major: selectedMajor,
          period: widget.period,
          dayOfWeek: widget.dayOfWeek,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'フィルター',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '学年',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: Grade.values.map(
              (grade) {
                return FilterChip(
                  label: Text(grade.label),
                  selected: selectedGrade == grade,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedGrade = isSelected ? grade : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '学期',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: Semester.values.map(
              (semester) {
                return FilterChip(
                  label: Text(semester.label),
                  selected: selectedSemester == semester,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedSemester = isSelected ? semester : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '専攻',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: Major.values.map(
              (major) {
                return FilterChip(
                  label: Text(major.label),
                  selected: selectedMajor == major,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedMajor = isSelected ? major : null;
                    });
                  },
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilledButton(
              onPressed: _applyFilter,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'フィルターを適用',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
