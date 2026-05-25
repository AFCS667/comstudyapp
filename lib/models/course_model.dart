class Module {
  final String id;
  final String title;
  final List<Lesson> lessons;

  const Module({required this.id, required this.title, this.lessons = const []});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] as String,
      title: json['title'] as String,
      lessons: (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String? durationText;
  final String? youtubeVideoId;
  final int sortOrder;

  const Lesson({
    required this.id,
    required this.title,
    this.durationText,
    this.youtubeVideoId,
    this.sortOrder = 0,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      durationText: json['duration_text'] as String?,
      youtubeVideoId: json['youtube_video_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class Course {
  final String id;
  final String title;
  final String? description;
  final String mentorName;
  final String? mentorBio;
  final String? durationText;
  final int totalLessons;
  final double rating;
  final List<Module> modules;

  const Course({
    required this.id,
    required this.title,
    this.description,
    required this.mentorName,
    this.mentorBio,
    this.durationText,
    this.totalLessons = 0,
    this.rating = 4.8,
    this.modules = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mentorName: json['mentor_name'] as String,
      mentorBio: json['mentor_bio'] as String?,
      durationText: json['duration_text'] as String?,
      totalLessons: json['total_lessons'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      modules: (json['modules'] as List<dynamic>?)
              ?.map((e) => Module.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
