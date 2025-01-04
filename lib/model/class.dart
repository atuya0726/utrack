import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utrack/model/constants.dart';

class ClassModel {
  // クラスのフィールドを定義
  final String id; // クラスID
  final String name; // クラス名
  final String professor; // 教授名
  final String place; // 教室の場所
  final List<Period> period; // 時限 (例: 1, 2, 3...）
  final Week dayOfWeek; // 曜日 (例: "Monday", "Tuesday"...)
  final Semester semester; // 学期
  final Major major; // 学部
  final List<int> grade; // 開講年次
  final List<String> users;
  bool get isContinuous => period.length > 1; // getter として定義

  // コンストラクタ
  ClassModel({
    required this.id,
    required this.name,
    required this.professor,
    required this.place,
    required this.period,
    required this.dayOfWeek,
    required this.semester,
    required this.major,
    required this.grade,
    required this.users,
  }); // isContinuous は不要

  // 空のクラスを作成する静的メソッド
  static ClassModel empty() {
    return ClassModel(
      id: '',
      name: '',
      professor: '',
      place: '',
      period: [],
      dayOfWeek: Week.mon, // デフォルト値として月曜日を設定
      semester: Semester.first, // デフォルト値として前期を設定
      major: Major.none,
      grade: [],
      users: [],
    );
  }

  // Firestoreデータをモデルに変換するメソッド
  static ClassModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final id = snapshot.id;
    final data = snapshot.data();

    return ClassModel(
      id: id,
      name: data?['name'] ?? '',
      professor: data?['professor'] ?? '',
      place: data?['place'] ?? '',
      period: PeriodExtension.fromJson((data?['period'] ?? []).cast<int>()),
      dayOfWeek: WeekExtension.fromJson(data?['dayOfWeek'] ?? 0),
      semester: SemesterExtension.fromLabel(data?['semester'] ?? ''),
      major: MajorExtension.fromLabel(data?['major'] ?? ''),
      grade: (data?['grade'] ?? []).cast<int>(),
      users: (data?['users'] ?? []).cast<String>(),
    );
  }

  // Firestoreにデータを変換するメソッド
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "professor": professor,
      "place": place,
      "period": period.map((p) => p.number).toList(),
      "dayOfWeek": dayOfWeek.number,
      "semester": semester,
      "major": major,
      "grade": grade,
      "users": users,
    };
  }
}
