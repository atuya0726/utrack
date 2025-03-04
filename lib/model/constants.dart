const dateFormat = 'y年M月d日 H:mm';

enum Grade {
  firstYear,
  secondYear,
  thirdYear,
  fourthYear,
  other,
}

extension GradeExtension on Grade {
  String get label {
    switch (this) {
      case Grade.firstYear:
        return '1年生';
      case Grade.secondYear:
        return '2年生';
      case Grade.thirdYear:
        return '3年生';
      case Grade.fourthYear:
        return '4年生';
      case Grade.other:
        return 'その他';
    }
  }

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
  other,
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
      case Week.other:
        return '他';
    }
  }

  static List<Week> getWeekdays() {
    return [
      Week.mon,
      Week.tue,
      Week.wed,
      Week.thu,
      Week.fri,
    ];
  }

  // ラベルからWeekを取得するヘルパーメソッド
  static Week fromJson(int number) {
    return Week.values
        .firstWhere((week) => week.number == number, orElse: () => Week.mon);
  }

  static Week fromLabel(String label) {
    return Week.values
        .firstWhere((week) => week.label == label, orElse: () => Week.mon);
  }
}

enum Period {
  first,
  second,
  third,
  fourth,
  fifth,
  other,
}

extension PeriodExtension on Period {
  // 数値を取得するプロパティ
  int get number => index + 1;

  // ラベル文字列を取得するプロパティ
  String get label {
    if (this == Period.other) {
      return '他';
    }
    return '$number限';
  }

  // ラベルからPeriodを取得するヘルパーメソッド
  static List<Period> fromJson(List<int> numbers) {
    return numbers
        .map(
          (number) => Period.values.firstWhere(
            (period) => period.number == number,
            orElse: () => Period.other,
          ),
        )
        .toList();
  }

  static Period fromNumber(int number) {
    return Period.values.firstWhere(
      (period) => period.number == number,
      orElse: () => Period.other,
    );
  }

  static Period fromString(String p) {
    return Period.values.firstWhere(
      (period) => period.number == p as num,
      orElse: () => Period.other,
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
      case Period.other:
        return 0;
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
      case Period.other:
        return 0;
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
    return HowToSubmit.values.firstWhere(
      (howToSubmit) => howToSubmit.label == label,
      orElse: () => HowToSubmit.online,
    );
  }
}

enum TaskType {
  report,
  presentation,
  test,
}

extension TaskTypeExtension on TaskType {
  String get label {
    switch (this) {
      case TaskType.report:
        return 'レポート';
      case TaskType.presentation:
        return '発表準備';
      case TaskType.test:
        return 'テスト';
    }
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

enum Semester {
  first,
  second,
  spring,
  summer,
  autumn,
  winter,
  other,
}

extension SemesterExtension on Semester {
  String get label {
    switch (this) {
      case Semester.first:
        return '前学期';
      case Semester.second:
        return '後学期';
      case Semester.spring:
        return '春学期';
      case Semester.summer:
        return '夏学期';
      case Semester.autumn:
        return '秋学期';
      case Semester.winter:
        return '冬学期';
      case Semester.other:
        return 'その他';
    }
  }

  static Semester fromLabel(String label) {
    return Semester.values.firstWhere(
      (semester) => semester.label == label,
      orElse: () => Semester.other,
    );
  }
}

enum Major {
  first,
  second,
  third,
  none,
  other,
}

extension MajorExtension on Major {
  String get label {
    switch (this) {
      case Major.first:
        return 'Ⅰ類';
      case Major.second:
        return 'Ⅱ類';
      case Major.third:
        return 'Ⅲ類';
      case Major.none:
        return '情報理工学域';
      case Major.other:
        return 'その他';
    }
  }

  static Major fromLabel(String label) {
    return Major.values.firstWhere(
      (major) => major.label == label,
      orElse: () => Major.other,
    );
  }
}
