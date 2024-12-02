import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/constants.dart';
import 'package:utrack/viewmodel/class.dart';

class RealTimeSearchBar extends StatefulWidget {
  const RealTimeSearchBar(
      {super.key, required this.dayOfWeek, required this.period});
  final Week dayOfWeek;
  final Period period;

  @override
  State<RealTimeSearchBar> createState() => _RealTimeSearchBarState();
}

class _RealTimeSearchBarState extends State<RealTimeSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ref = ProviderScope.containerOf(context);
    return TextField(
      controller: _searchController,
      onChanged: (text) {
        ref.read(classProvider.notifier).searchClasses(
            text: text, dayOfWeek: widget.dayOfWeek, period: widget.period);
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: const Icon(Icons.search),
        hintText: '検索',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
