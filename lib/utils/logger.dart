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

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kReleaseMode) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    } else {
      debugPrint('ERROR: $message');
      if (error != null) debugPrint(error.toString());
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}
