import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/configs/ApiConfig.dart';

class AuthService {
  static Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', data['token'] ?? '');
    await prefs.setString('user_name', data['hoTen'] ?? '');
    await prefs.setInt('user_id', data['id'] ?? 0);
    await prefs.setString('user_email', data['email'] ?? '');
    await prefs.setString('user_role', data['vaiTro'] ?? '');
    await prefs.setString('user_avatar', data['avatarUrl'] ?? '');
  }

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/Auth/Login");

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      await saveUserData(jsonDecode(res.body));
      return true;
    }
    return false;
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse("$ApiConfig/Auth/Register");
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'hoTen': name,
        'email': email,
        'password': password,
        'vaiTro': role,
      }),
    );
    if (res.statusCode == 200) {
      await saveUserData(jsonDecode(res.body));
      return true;
    }
    return false;
  }

  /// PUT /api/Auth/change-password
  static Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      throw Exception('Chưa đăng nhập');
    }

    final url = Uri.parse("${ApiConfig.baseUrl}/Auth/change-password");

    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      print("❌ Change password failed: ${res.body}");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'role': prefs.getString('user_role') ?? '',
      'avatar': prefs.getString('user_avatar'),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
