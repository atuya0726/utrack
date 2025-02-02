import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String? tag}) {
    if (kReleaseMode) {
      // プロダクション環境での処理
      // Firebase Crashlytics や他のサービスにログを送信
      // FirebaseCrashlytics.instance.log(message);
    } else {
      // 開発環境での処理
      debugPrint('[$tag] $message');
    }
  }

  static void error(String message,
      {Object? error, StackTrace? stackTrace, String? tag}) {
    if (kReleaseMode) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    } else {
      debugPrint('[$tag] ERROR: $message');
      if (error != null)
        debugPrint('[$tag] Error details: ${error.toString()}');
      if (stackTrace != null) debugPrint('[$tag] Stack trace:\n$stackTrace');
    }
  }
}
