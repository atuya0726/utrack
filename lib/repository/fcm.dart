import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepository {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<NotificationSettings> requestPermission() async {
    // 現在の通知設定を取得
    final settings = await _messaging.getNotificationSettings();
    
    // まだ許可されていない場合のみ権限をリクエスト
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      return _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    return settings;
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}
