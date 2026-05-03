import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.0.2.2:3000/api";

  // Register a new user
  Future<bool> Register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return response.statusCode ==
        201; // Placeholder for successful registration
  }

  Future<bool?> Login(String email, String password) async {
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
