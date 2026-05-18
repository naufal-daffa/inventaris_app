import 'dart:convert';
import 'package:inventory_apps/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final url = "${ApiConfig.baseUrl}login";
    print(url);
    print("Data username : $username, password: $password");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": "$username", "password": "$password"}),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String token = data['data']['token'];
        final String name = data['data']['data']['name'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("name", name);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
      await prefs.remove("name");
      print("Logout successfully");
    } catch (e) {
      print("Logout failed: $e");
    }
  }
}
