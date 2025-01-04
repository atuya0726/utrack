import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/viewmodel/user_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  Grade? _selectedGrade;
  Major? _selectedMajor;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Firebaseでユーザーを作成
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // ユーザー設定を保存
      await ref.read(userProvider.notifier).makeUser(
            userId: userCredential.user!.uid,
            grade: _selectedGrade,
            major: _selectedMajor,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('アカウントを作成しました')),
        );
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      switch (e.code) {
        case 'weak-password':
          message = 'パスワードが弱すぎます';
          break;
        case 'email-already-in-use':
          message = 'このメールアドレスは既に使用されています';
          break;
        case 'invalid-email':
          message = '無効なメールアドレスです';
          break;
        default:
          message = 'エラーが発生しました: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント登録'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  if (!value.contains('@')) {
                    return '有効なメールアドレスを入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください';
                  }
                  if (value.length < 6) {
                    return 'パスワードは6文字以上で入力してください';
                  }
                  return null;
                },
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
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
              const SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: _register,
                child: const Text('登録'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
