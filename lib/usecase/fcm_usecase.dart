import 'package:utrack/repository/fcm.dart';
import 'package:utrack/usecase/user_usecase.dart';

class NotificationUseCase {
  final NotificationRepository _notificationRepository;
  final UserUsecase _userUsecase;

  NotificationUseCase({
    NotificationRepository? notificationRepository,
    UserUsecase? userUsecase,
  })  : _notificationRepository = notificationRepository ?? NotificationRepository(),
        _userUsecase = userUsecase ?? UserUsecase();

  Future<void> initialize(String userId) async {
    // 通知権限の要求
    await _notificationRepository.requestPermission();

    // 初期トークンの取得と保存
    final token = await _notificationRepository.getToken();
    if (token != null) {
      await _saveToken(token, userId);
    }

    // トークンの更新監視
    _notificationRepository.onTokenRefresh.listen((token) {
      _saveToken(token, userId);
    });
  }

  Future<void> _saveToken(String token, String userId) async {
    await _userUsecase.updateNotificationToken(
      userId: userId,
      token: token,
    );
  }
}
