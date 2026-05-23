class ForumPost {
  final String id;
  final String avatarUrl;
  final String title;
  final String meta;
  final String excerpt;
  final List<String> tags;
  final List<ForumReply> repliesList;
  int replies;
  int likes;
  bool isHighlight;

  ForumPost({
    required this.id,
    required this.avatarUrl,
    required this.title,
    required this.meta,
    required this.excerpt,
    required this.tags,
    required this.repliesList,
    this.replies = 0,
    this.likes = 0,
    this.isHighlight = false,
  });

factory ForumPost.fromJson(Map<String, dynamic> json, {List<ForumReply>? repliesData}) {
    return ForumPost(
      id: json['id'].toString(),
      avatarUrl: json['avatar_url'] ?? '',
      title: json['title'] ?? '',
      meta: json['meta'] ?? '',
      excerpt: json['excerpt'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      repliesList: repliesData ?? [],
      replies: json['replies'] ?? 0,
      likes: json['likes'] ?? 0,
      isHighlight: json['is_highlight'] ?? false,
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
class ForumReply{
  final String id;
  final String avatarUrl;
  final String senderName;
  final String time;
  final String message;

  ForumReply({
    required this.id,
    required this.avatarUrl,
    required this.senderName,
    required this.time,
    required this.message,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
      id: json['id'].toString(),
      avatarUrl: json['avatar_url'] ?? '',
      senderName: json['sender_name'] ?? '',
      time: json['time'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson(String postId) {
    return {
      'post_id': postId,
      'avatar_url': avatarUrl,
      'sender_name': senderName,
      'time': time,
      'message': message,
    };
  }
}

