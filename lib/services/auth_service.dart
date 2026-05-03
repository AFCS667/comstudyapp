import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000/users';

  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': name, 'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 10), 
    onTimeout: () {
      // Handle timeout
      return http.Response('Error: Request timed out', 408);
    });
    return response.statusCode == 201; // Placeholder for successful registration
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }

     // Placeholder for successful login response

  }
}
