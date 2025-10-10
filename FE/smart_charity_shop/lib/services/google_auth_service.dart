import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/configs/ApiConfig.dart';
import 'auth_service.dart';

class GoogleAuthService {
  static Future<bool> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      await googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final email = googleUser.email;
      final name = googleUser.displayName ?? '';
      final googleId = googleUser.id;
      final avatar = googleUser.photoUrl ?? '';

      final url = Uri.parse("${ApiConfig.baseUrl}/Auth/login-google");
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'hoTen': name,
          'googleId': googleId,
          'avatarUrl': avatar,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await AuthService.saveUserData(data);
        return true;
      } else {
        print('GoogleLogin error ${res.statusCode}: ${res.body}');
        return false;
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
      return false;
    }
  }

  /// Đăng xuất Google
  static Future<void> signOutGoogle() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
