import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/viewmodel/user_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Grade? _selectedGrade;
  Major? _selectedMajor;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user != null) {
      setState(() {
        _selectedGrade = user.grade;
        _selectedMajor = user.major;
      });
    }
  }

  Future<void> _updateSettings() async {
    final user = ref.read(userProvider);
    if (user != null) {
      await ref.read(userProvider.notifier).updateUser(
            userId: user.id,
            grade: _selectedGrade,
            major: _selectedMajor,
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('設定を更新しました')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('ログインしてください'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'メールアドレス',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('未設定'),
            const SizedBox(height: 24),
            const Text(
              '学年',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: Grade.values.map((grade) {
                return ChoiceChip(
                  label: Text(grade.label),
                  selected: _selectedGrade == grade,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGrade = selected ? grade : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              '専攻',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: Major.values.map((major) {
                return ChoiceChip(
                  label: Text(major.label),
                  selected: _selectedMajor == major,
                  onSelected: (selected) {
                    setState(() {
                      _selectedMajor = selected ? major : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateSettings,
                child: const Text('設定を更新'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
