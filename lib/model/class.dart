class ClassModel {
  // クラスのフィールドを定義
  final String id; // クラスID
  final String name; // クラス名
  final String professor; // 教授名
  final String place; // 教室の場所
  final int period; // 時限 (例: 1, 2, 3...）
  final String dayOfWeek; // 曜日 (例: "Monday", "Tuesday"...)
  final String semester; // 学期 ("前期" または "後期")
  final int year; // 開講年次

  // コンストラクタ
  ClassModel({
    required this.id,
    required this.name,
    required this.professor,
    required this.place,
    required this.period,
    required this.dayOfWeek,
    required this.semester,
    required this.year,
  });
}
