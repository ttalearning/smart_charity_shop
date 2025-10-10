import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/ApiConfig.dart';
import '../models/order_request.dart';

class OrderService {
  /// POST /api/HoaDon
  static Future<Map<String, dynamic>> createOrder(OrderRequest req) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    final url = Uri.parse('${ApiConfig.baseUrl}/HoaDon/$userId');

    // Lấy token nếu có (auth)
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('auth_token');

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Tạo hóa đơn thất bại [${res.statusCode}]: ${res.body}');
    }
  }
}
