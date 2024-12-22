import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:utrack/constants.dart';
import 'firestore.dart';

// main関数。非同期処理(await)を使用するのでasync。
void main() async {
  // 取得先のURLを元にして、Uriオブジェクトを生成する。
  const year = '2024';
  const baseUrl = 'https://kyoumu.office.uec.ac.jp/syllabus/$year/';
  const url = '${baseUrl}GakkiIchiran_31_0.html';
  final target = Uri.parse(url);

  // 取得する。
  final response = await http.get(target);
  final body = utf8.decode(response.bodyBytes);
  // ステータスコードをチェックする。「200 OK」以外のときはその旨を表示して終了する。
  if (response.statusCode != 200) {
    print('ERROR: ${response.statusCode}');
    return;
  }

  Map data = {};
  // 取得したHTMLのボディをパースする。
  final document = parse(body);
  int count = 0;

  final p = document.querySelectorAll('tbody')[8].querySelectorAll('tr');
  for (final elm in p) {
    final tds = elm.querySelectorAll('td');
    final period = tds[3].text;
    data = {
      ...getPeriod(period),
    };
    final classLink = tds[5].querySelector('a')?.attributes['href'];

    final classLinkUri = Uri.parse('$baseUrl$classLink');
    final classResponse = await http.get(classLinkUri);
    final classBody = utf8.decode(classResponse.bodyBytes);
    final classDocument = parse(classBody);
    final classTable = classDocument.querySelectorAll('tbody tr');
    final result = classTable
        .map((e) => e.querySelectorAll('td').map((elm) => elm.text).toList())
        .expand((e) => e)
        .toList();
    data['name'] = result[3];
    data['grade'] = result[7].replaceAll(RegExp(r'\s+'), '');
    data['semester'] = result[8];
    data['professor'] = result[14].replaceAll(RegExp(r'\s+'), '');
    data['place'] = '';
    data['users'] = [];

    final cls = {
      'name': data['name'],
      'professor': data['professor'],
      'place': '',
      'period': data['period'],
      'dayOfWeek': data['week'],
      'semester': data['semester'],
      'grade': getGrade(data['grade']),
      'users': [],
    };

    await addClass(cls, year);
    count++;
    print(count);
    // if (count == 3) {
    //   break;
    // }

    await Future.delayed(Duration(seconds: 5)); // 5秒待つ
  }
}

Map getPeriod(String period) {
  final periods = period.split(',').map((e) => e.trim()).toList();

  // 曜日の取得
  final firstDay = periods[0][0];
  final week = firstDay == '他'
      ? 7 // '他'の場合は7として扱う
      : WeekExtension.fromLabel(firstDay).number;

  // 時限の取得
  final periodNumbers = periods.map((e) {
    final timeStr = e.substring(1);
    // '他'の場合は0として扱う
    if (timeStr == '他') return 7;
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
