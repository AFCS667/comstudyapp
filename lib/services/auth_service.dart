import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.218.165.43:3000/users";

  // Register a new user
  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': name, 'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 10), 
    onTimeout: () {
      // Handle timeout
      return http.Response('Error: Request timed out', 408);
    });
    return response.statusCode == 201; // Placeholder for successful registration
  }

  Future<bool?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['mybinigwe'];
    }
    return null;
  }
}
