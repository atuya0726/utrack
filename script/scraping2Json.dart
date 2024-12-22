import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() async {
  const year = '2024';
  const baseUrl = 'https://kyoumu.office.uec.ac.jp/syllabus/$year/';
  const url = '${baseUrl}GakkiIchiran_31_0.html';
  final target = Uri.parse(url);

  final response = await http.get(target);
  final body = utf8.decode(response.bodyBytes);

  if (response.statusCode != 200) {
    print('エラー: ${response.statusCode}');
    return;
  }

  List<Map<String, dynamic>> classDataList = [];
  final document = parse(body);
  int count = 0;

  final p = document.querySelectorAll('tbody')[8].querySelectorAll('tr');
  for (final elm in p) {
    final tds = elm.querySelectorAll('td');
    final period = tds[3].text;

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

    final classData = {
      'name': result[3],
      'professor': result[14].replaceAll(RegExp(r'\s+'), ''),
      'semester': result[8],
      'grade': result[7].replaceAll(RegExp(r'\s+'), ''),
      'time': period,
      'syllabusUrl': classLinkUri.toString(),
    };

    classDataList.add(classData);
    count++;
    print('処理済み: $count');

    await Future.delayed(Duration(seconds: 3));
  }

  // JSONファイルとして保存（整形して見やすく）
  final jsonString = JsonEncoder.withIndent('  ').convert(classDataList);
  final file = File('./script/json/class_data_raw_$year.json');
  await file.writeAsString(jsonString);
  print('データを保存しました: ${file.path}');
}
