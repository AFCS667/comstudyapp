class Reply {
  final String id;
  final String postId;
  final String avatarUrl;
  final String senderName;
  final String time;
  final String message;
  final DateTime createdAt;

  Reply({
    required this.id,
    required this.postId,
    required this.avatarUrl,
    required this.senderName,
    required this.time,
    required this.message,
    required this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      senderName: json['sender_name'] as String? ?? '',
      time: json['time'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'avatar_url': avatarUrl,
      'sender_name': senderName,
      'time': time,
      'message': message,
    };
  }
}
