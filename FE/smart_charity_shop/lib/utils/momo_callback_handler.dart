import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';
import '../ui/screens/donate_success_screen.dart';
import '../ui/screens/order_success_screen.dart';

class MomoCallbackHandler {
  static final AppLinks _appLinks = AppLinks();
  static String? _lastHandledUri;

  static Future<void> initListener(BuildContext context) async {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleUri(context, uri);
    });
  }

  static Future<void> _handleUri(BuildContext context, Uri uri) async {
    final uriStr = uri.toString();
    if (uriStr == _lastHandledUri) {
      print("⚠️ Bỏ qua callback trùng: $uriStr");
      return;
    }
    _lastHandledUri = uriStr;

    print("🔗 Callback URI: $uriStr");
    final resultCode = uri.queryParameters['resultCode'];
    if (resultCode != "0") return;

    try {
      // 🧩 Giải mã extraData để biết loại giao dịch
      final extraEncoded = uri.queryParameters['extraData'] ?? "";
      Map<String, dynamic>? extra;
      if (extraEncoded.isNotEmpty) {
        final decoded = utf8.decode(base64.decode(extraEncoded));
        extra = jsonDecode(decoded);
      }

      final type = extra?['type'] ?? 'unknown';
      final id = extra?['id'];
      print("🧠 Giao dịch loại: $type | id: $id");

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final amount = prefs.getDouble('last_donation_amount') ?? 0;

      if (type == "donate") {
        final campaignId = id ?? prefs.getInt('last_campaign_id');
        if (campaignId == null) {
          print("⚠️ Không tìm thấy campaignId");
          return;
        }

        final res = await http.post(
          Uri.parse("${ApiConfig.baseUrl}/DongGop/create"),
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "chienDichId": campaignId,
            "soTien": amount,
            "loaiNguon": "MoMo",
          }),
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          print("✅ Đóng góp thành công");
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DonateSuccessScreen()),
            );
          }
        }
      } else if (type == "order") {
        print("🧾 Thanh toán hóa đơn #$id thành công!");
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderSuccessScreen(id: id)),
          );
        }
      }
    } catch (e) {
      print("🔴 Lỗi xử lý callback MoMo: $e");
    }
  }
}
