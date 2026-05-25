class Post {
  final String id;
  final String avatarUrl;
  final String title;
  final String meta;
  final String excerpt;
  final List<String> tags;
  final int replies;
  final int likes;
  final bool isHighlight;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.avatarUrl,
    required this.title,
    required this.meta,
    required this.excerpt,
    required this.tags,
    required this.replies,
    required this.likes,
    required this.isHighlight,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      meta: json['meta'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      replies: json['replies'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      isHighlight: json['is_highlight'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar_url': avatarUrl,
      'title': title,
      'meta': meta,
      'excerpt': excerpt,
      'tags': tags,
      'replies': replies,
      'likes': likes,
      'is_highlight': isHighlight,
    };
  }
}
