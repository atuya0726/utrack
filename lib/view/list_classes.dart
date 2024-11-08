import 'package:flutter/material.dart';
import 'package:utrack/model/class.dart';
import 'package:utrack/view/mock_variables.dart';

class ClassesList extends StatelessWidget {
  const ClassesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        title: Center(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: const Icon(Icons.search),
              hintText: 'Search class',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: classes.length * 2,
        itemBuilder: (context, index) {
          if (index.isEven) {
            return __buildListTile(context, classes[index ~/ 2]);
          } else {
            return const Divider(height: 0);
          }
        },
      ),
    );
  }

  ListTile __buildListTile(BuildContext context, ClassModel cls) {
    return ListTile(
      leading: const Icon(Icons.access_alarm),
      title: Text(
        cls.name,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: const Text('朝ごはんはとても大事'),
      tileColor: Theme.of(context).colorScheme.surface,
    );
  }
}
