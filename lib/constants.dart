const dateFormat = 'y年M月d日 H:mm';

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

  // ラベルからWeekを取得するヘルパーメソッド
  static Week fromJson(int number) {
    return Week.values
        .firstWhere((week) => week.number == number, orElse: () => Week.mon);
  }

  static Week fromLabel(String label) {
    return Week.values.firstWhere((week) => week.label == label);
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
  static List<Period> fromJson(List<int> numbers) {
    return numbers
        .map(
          (number) => Period.values.firstWhere(
            (period) => period.number == number,
          ),
        )
        .toList();
  }

  static Period fromNumber(int number) {
    return Period.values.firstWhere((period) => period.number == number);
  }

  static Period fromString(String p) {
    return Period.values.firstWhere((period) => period.number == p as num);
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

extension HowToSubmitExtension on HowToSubmit {
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

  static HowToSubmit fromLabel(String label) {
    return HowToSubmit.values
        .firstWhere((howToSubmit) => howToSubmit.label == label);
  }
}

enum TaskType {
  report,
  exercise,
  presentation,
  test,
}

extension TaskTypeExtension on TaskType {
  String get label {
    switch (this) {
      case TaskType.report:
        return 'レポート';
      case TaskType.exercise:
        return '演習';
      case TaskType.presentation:
        return '発表準備';
      case TaskType.test:
        return 'テスト';
    }
  }
}

enum TimeSpent {
  lessThanHour, // 1時間未満
  oneToFour, // 1-4時間
  moreThanFour // 4時間以上
}

extension TimeSpentExtension on TimeSpent {
  String get label {
    switch (this) {
      case TimeSpent.lessThanHour:
        return '1時間未満';
      case TimeSpent.oneToFour:
        return '1-4時間';
      case TimeSpent.moreThanFour:
        return '4時間以上';
    }
  }

  static TimeSpent fromLabel(String label) {
    return TimeSpent.values.firstWhere(
      (timeSpent) => timeSpent.label == label,
      orElse: () => TimeSpent.lessThanHour,
    );
  }
}

enum TaskStatus {
  canceled,
  expired,
  inProgress,
  completed,
}

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.canceled:
        return '諦めた';
      case TaskStatus.expired:
        return '期限切れ';
      case TaskStatus.inProgress:
        return '進行中';
      case TaskStatus.completed:
        return '完了';
    }
  }
}
