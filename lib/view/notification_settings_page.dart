import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  String? _fcmToken;
  bool _isLoading = true;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _loadStatus();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 通知ダイアログを表示
      if (mounted && message.notification != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message.notification?.title ?? '通知'),
            content: Text(message.notification?.body ?? '新しい通知があります'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _loadStatus() async {
    await _checkPermission();
    await _loadFCMToken();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.notification.request();
    setState(() {
      _permissionStatus = status;
    });
    if (status.isGranted) {
      await _loadFCMToken();
    }
  }

  Future<void> _loadFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _fcmToken = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('トークンの取得に失敗しました: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _sendTestNotification() async {
    if (_fcmToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('FCMトークンが設定されていないため、テスト通知を送信できません'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url =
          Uri.parse('${dotenv.env['NOTIFICATION_URL']}?token=$_fcmToken');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('テスト通知を送信しました')),
          );
        }
      } else {
        throw Exception('ステータスコード: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('テスト通知の送信に失敗しました: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getPermissionText() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
        return '許可済み';
      case PermissionStatus.denied:
        return '拒否';
      case PermissionStatus.permanentlyDenied:
        return '永続的に拒否';
      case PermissionStatus.restricted:
        return '制限付き';
      case PermissionStatus.limited:
        return '制限付き';
      case PermissionStatus.provisional:
        return '仮許可';
      default:
        return '不明';
    }
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定状態'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '通知権限',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _getPermissionText(),
                        style: TextStyle(
                          color: _getPermissionColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (!_permissionStatus.isGranted)
                        ElevatedButton(
                          onPressed: _requestPermission,
                          child: const Text('権限を要求'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'FCMトークンステータス',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _fcmToken != null ? '設定済み' : '未設定',
                    style: TextStyle(
                      color: _fcmToken != null ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_fcmToken != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'トークン:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _fcmToken!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sendTestNotification,
                      child: const Text('テスト通知を送信'),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
