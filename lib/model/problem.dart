final String tableProblems = 'problems';

class ProblemFields {
  static final List<String> values = [
    // all fields
    id, user_id, problem, date, scale
  ];

  static final String id = '_id';
  static final String user_id = 'user_id';
  static final String problem = 'problem';
  static final String date = 'date';
  static final String scale = 'scale';
}

class Problem {
  final int id;
  final int user_id;
  final String problem;
  DateTime date;
  final String scale;

  Problem({
    this.id,
    this.user_id,
    this.problem,
    this.date,
    this.scale,
  });

  Problem copy({
    int id,
    int user_id,
    String problem,
    DateTime date,
    String scale,
  }) =>
      Problem(
        id: id ?? this.id,
        user_id: user_id ?? this.user_id,
        problem: problem ?? this.problem,
        date: date ?? this.date,
        scale: scale ?? this.scale,
      );

  static Problem fromMap(Map<String, Object> map) => Problem(
        id: map[ProblemFields.id] as int,
        user_id: map[ProblemFields.user_id] as int,
        problem: map[ProblemFields.problem] as String,
        date: DateTime.parse(map[ProblemFields.date] as String),
        scale: map[ProblemFields.scale] as String,
      );

  Map<String, Object> toMap() => {
        ProblemFields.id: id,
        ProblemFields.user_id: user_id,
        ProblemFields.problem: problem,
        ProblemFields.date: date.toString(),
        ProblemFields.scale: scale,
      };
  int getId() {
    return id;
  }

  int getUserId() {
    return user_id;
  }

  String getScale() {
    return scale;
  }

  String getProblem() {
    return problem;
  }

  DateTime getDate() {
    return date;
  }
}
