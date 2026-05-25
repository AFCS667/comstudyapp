class QuizOption {
  final String id;
  final String optionText;
  final bool isCorrect;
  final int sortOrder;

  const QuizOption({
    required this.id,
    required this.optionText,
    required this.isCorrect,
    this.sortOrder = 0,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class QuizQuestion {
  final String id;
  final String questionText;
  final List<QuizOption> options;
  final int sortOrder;

  const QuizQuestion({
    required this.id,
    required this.questionText,
    this.options = const [],
    this.sortOrder = 0,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      options: (json['quiz_options'] as List<dynamic>?)
              ?.map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class Quiz {
  final String id;
  final String title;
  final int timeLimitSeconds;
  final double passingScore;
  final List<QuizQuestion> questions;

  const Quiz({
    required this.id,
    required this.title,
    this.timeLimitSeconds = 300,
    this.passingScore = 70.0,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      timeLimitSeconds: json['time_limit_seconds'] as int? ?? 300,
      passingScore: (json['passing_score'] as num?)?.toDouble() ?? 70.0,
      questions: (json['quiz_questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
