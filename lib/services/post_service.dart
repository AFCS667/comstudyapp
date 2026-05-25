import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:comstudyapp/models/post_model.dart';
import 'package:comstudyapp/models/reply_model.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Post>> fetchPosts() async {
    final response = await _supabase
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return response.map((json) => Post.fromJson(json)).toList();
  }

  Future<List<Reply>> fetchReplies(String postId) async {
    final response = await _supabase
        .from('replies')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    return response.map((json) => Reply.fromJson(json)).toList();
  }

  Future<void> createPost({
    required String avatarUrl,
    required String title,
    required String meta,
    required String excerpt,
    required List<String> tags,
  }) async {
    await _supabase.from('posts').insert({
      'avatar_url': avatarUrl,
      'title': title,
      'meta': meta,
      'excerpt': excerpt,
      'tags': tags,
      'replies': 0,
      'likes': 0,
      'is_highlight': false,
    });
  }

  Future<void> incrementLikes(String postId, int currentLikes) async {
    await _supabase
        .from('posts')
        .update({'likes': currentLikes + 1})
        .eq('id', postId);
  }
}
