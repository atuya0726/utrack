import 'dart:convert';
import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:utrack/model/constants.dart';

// データ処理用の関数
List<Map<String, dynamic>> processClassData(List<dynamic> jsonData) {
  final processedData = <Map<String, dynamic>>[];

  for (final classData in jsonData) {
    // 時限の処理
    final timeStr = classData['time'] as String;
    final periodInfo = getPeriod(timeStr);

    // 学年の処理
    final gradeStr = classData['grade'] as String;
    final grades = getGrade(gradeStr);

    // 処理したデータを追加
    processedData.add({
      'name': classData['name'],
      'professor': classData['professor'],
      'semester': classData['semester'],
      'grade': grades,
      'period': periodInfo['period'],
      'major': classData['major'],
      'dayOfWeek': periodInfo['week'],
      'place': '',
      'users': [],
    });
  }

  return processedData;
}

// Firestoreへのアップロード用の関数
Future<void> uploadToFirestore(List<Map<String, dynamic>> processedData) async {
  final admin = FirebaseAdminApp.initializeApp(
    'utrack-dev',
    Credential.fromServiceAccount(
      File('script/credential.json'),
    ),
  );

  try {
    final firestore = Firestore(admin);
    final classesRef = firestore.collection('uec/2024/classes');
    final futures = <Future>[];

    for (final data in processedData) {
      futures.add(classesRef.doc().set(data));
    }

    await Future.wait(futures);
    print('データのアップロードが完了しました');
  } finally {
    // 確実にクリーンアップを行う
    await admin.close().timeout(
          const Duration(seconds: 5),
          onTimeout: () => print('接続のクローズがタイムアウトしました'),
        );
  }
}

Map getPeriod(String period) {
  final periods = period.split(',').map((e) => e.trim()).toList();

  // 曜日の取得
  final firstDay = periods[0][0];
  final week = WeekExtension.fromLabel(firstDay).number;
  print(week);

  if (week == 6) {
    return {
      'week': 6,
      'period': [7],
    };
  }

  // 時限の取得
  final periodNumbers = periods.map((e) {
    if (e[0] == '他') return 7;
    final timeStr = e.substring(1);

    try {
      return PeriodExtension.fromNumber(int.parse(timeStr)).number;
    } catch (e) {
      print('時限の解析でエラーが発生しました: $timeStr');
      return 7; // エラーの場合は0として扱う
    }
  }).toList();

  return {
    'week': week,
    'period': periodNumbers,
  };
}

List<int> getGrade(String grade) {
  try {
    return grade.split('/').map((e) => int.parse(e.trim())).toList();
  } catch (e) {
    print('学年データの解析でエラーが発生しました: $grade');
    return [0]; // デフォルト値としてその他
  }
}

// メイン処理
Future<void> importClassDataToFirestore() async {
  final file = File('script/json/class_data_raw_2024.json');
  final jsonString = await file.readAsString();
  final List<dynamic> jsonData = json.decode(jsonString);

  final processedData = processClassData(jsonData);
  await uploadToFirestore(processedData);
}

void main() async {
  try {
    await importClassDataToFirestore();
  } catch (e) {
    print('エラーが発生しました: $e');
  }
}
