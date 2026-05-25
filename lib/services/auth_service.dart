import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Register
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'username': name},
    );

    // Create profile after successful signup
    final userId = response.user?.id;
    if (userId != null) {
      await _supabase.from('profiles').insert({
        'id': userId,
        'full_name': name,
      });
    }

    return response;
  }

  // Login
  Future<AuthResponse> login(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
