const dateFormat = 'y年M月d日 hh:mm';

enum Grade {
  firstYear,
  secondYear,
  thirdYear,
  fourthYear,
}

extension GradeExtension on Grade {
  String get label => '$number年生';

  int get number => index + 1;

  static Grade fromLabel(String label) {
    return Grade.values.firstWhere(
      (grade) => grade.label == label,
      orElse: () => Grade.firstYear,
    );
  }
}

enum Week {
  mon,
  tue,
  wed,
  thu,
  fri,
}

extension WeekExtension on Week {
  // 数値を取得するプロパティ（1から始まる）
  int get number => index + 1;

  // ラベルを取得するプロパティ
  String get label {
    switch (this) {
      case Week.mon:
        return '月';
      case Week.tue:
        return '火';
      case Week.wed:
        return '水';
      case Week.thu:
        return '木';
      case Week.fri:
        return '金';
    }
  }
}

enum Period {
  first,
  second,
  third,
  fourth,
  fifth,
}

extension PeriodExtension on Period {
  // 数値を取得するプロパティ
  int get number => index + 1;

  // ラベル文字列を取得するプロパティ
  String get label => '$number限';

  // ラベルからPeriodを取得するヘルパーメソッド
  static Period fromLabel(String label) {
    return Period.values.firstWhere(
      (period) => period.label == label,
      orElse: () => Period.first,
    );
  }

  // 時限ごとの開始時刻（時）を返すプロパティ
  int get startTimeHour {
    switch (this) {
      case Period.first:
        return 9;
      case Period.second:
        return 10;
      case Period.third:
        return 13;
      case Period.fourth:
        return 14;
      case Period.fifth:
        return 16;
    }
  }

  // 時限ごとの開始時刻（分）を返すプロパティ
  int get startTimeMinute {
    switch (this) {
      case Period.first:
        return 0;
      case Period.second:
        return 40;
      case Period.third:
        return 0;
      case Period.fourth:
        return 40;
      case Period.fifth:
        return 15;
    }
  }
}

enum HowToSubmit {
  online,
  offline,
  posting,
}

extension HowToSubmitExtensiton on HowToSubmit {
  String get label {
    switch (this) {
      case HowToSubmit.online:
        return 'オンライン';
      case HowToSubmit.offline:
        return '手渡し';
      case HowToSubmit.posting:
        return '投函';
    }
  }
}
