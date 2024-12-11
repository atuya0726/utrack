import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utrack/repository/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();

  String infoText = '';
  String email = '';
  String password = '';
  bool isLogin = true;

  Future<void> _handleAuthAction() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (isLogin) {
          // ログイン処理
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          // ユーザー登録処理
          final user = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await userRepository.makeUser(userId: user.user!.uid);
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
          case 'user-not-found':
            message = 'ユーザーが見つかりません';
            break;
          case 'wrong-password':
            message = 'パスワードが間違っています';
            break;
          default:
            message = 'エラーが発生しました: ${e.message}';
        }
        setState(() {
          infoText = message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'ログイン' : 'アカウント作成'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    prefixIcon: Icon(Icons.email),
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
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'パスワード',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'パスワードを入力してください';
                    }
                    if (value.length < 6) {
                      return 'パスワードは6文字以上である必要があります';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                if (infoText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      infoText,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _handleAuthAction,
                    child: Text(
                      isLogin ? 'ログイン' : 'アカウント作成',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      infoText = '';
                      _formKey.currentState?.reset();
                    });
                  },
                  child: Text(
                    isLogin ? 'アカウントを作成' : 'ログインに戻る',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}