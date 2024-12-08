import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:utrack/constants.dart';
import 'firestore.dart';

// main関数。非同期処理(await)を使用するのでasync。
void main() async {
  // 取得先のURLを元にして、Uriオブジェクトを生成する。
  const baseUrl = 'https://kyoumu.office.uec.ac.jp/syllabus/2024/';
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
    data['year'] = result[7].replaceAll(RegExp(r'\s+'), '');
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
      'year': getYear(data['year']),
      'users': [],
    };

    await addClass(cls);
    count++;
    if (count == 10) {
      break;
    }
  }
}

Map getPeriod(String period) {
  Map data = {};
  if (period.length == 2) {
    // 単一の時限の場合（例：「月1」）
    final week = WeekExtension.fromLabel(period[0]).number;
    final p = PeriodExtension.fromNumber(int.parse(period[1])).number;
    data['week'] = week;
    data['period'] = [p];
  } else {
    // 複数の時限の場合（例：「月1,月2」）
    final periods = period.split(',').map((e) => e.trim());
    final week = WeekExtension.fromLabel(periods.first[0]).number;
    final periodNumbers = periods
        .map((e) => PeriodExtension.fromNumber(int.parse(e[1])).number)
        .toList();

    data['week'] = week;
    data['period'] = periodNumbers;
  }
  return data;
}

List<int> getYear(String year) {
  return year.split('/').map((e) => int.parse(e.trim())).toList();
}
