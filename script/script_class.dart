import 'package:utrack/constants.dart';

class ScriptClassModel {
  final String id;
  final String name;
  final String professor;
  final String place;
  final List<Period> period;
  final Week dayOfWeek;
  final String semester;
  final int year;
  final List<String> users;

  ScriptClassModel({
    required this.id,
    required this.name,
    required this.professor,
    required this.place,
    required this.period,
    required this.dayOfWeek,
    required this.semester,
    required this.year,
    required this.users,
  });
}
