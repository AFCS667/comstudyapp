import "package:shared_preferences/shared_preferences.dart";

class SessionManager {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);

    await prefs.setInt('login_time', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    final int? loginTime = prefs.getInt('login_time');

    if (token == null || loginTime == null) {
      return null;
    }

    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    final int sevenDaysInMillis = 7 * 24 * 60 * 60 * 1000;

    if (currentTime - loginTime > sevenDaysInMillis) {
      await prefs.clear();
      return null;
    }

    return token;
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
