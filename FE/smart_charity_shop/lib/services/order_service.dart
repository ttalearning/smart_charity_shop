import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/api_config.dart';
import '../models/order_request.dart';

class OrderService {
  /// POST /api/HoaDon
  static Future<Map<String, dynamic>> createOrder(
    OrderRequest req, {
    String? trangThaiThanhToan, // thêm tuỳ chọn
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    if (userId == null || userId == 0) {
      print("-------------------------Lỗi: Không tìm thấy user ID hợp lệ.");
      throw Exception("Lỗi: Không tìm thấy user ID hợp lệ.");
    }
    final url = Uri.parse('${ApiConfig.baseUrl}/HoaDon/$userId');

    final token = prefs.getString('jwt_token');

    final body = req.toJson();
    if (trangThaiThanhToan != null) {
      body['trangThaiThanhToan'] = trangThaiThanhToan;
    }

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Tạo hóa đơn thất bại [${res.statusCode}]: ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> getOrderDetail(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final userId = prefs.getInt('user_id') ?? 0;

    final url = Uri.parse('${ApiConfig.baseUrl}/HoaDon/$id/$userId');

    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Không lấy được chi tiết hóa đơn [${res.statusCode}]: ${res.body}',
      );
    }
  }

  static Future<List<dynamic>> fetchMyOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    final token = prefs.getString('jwt_token');

    final url = Uri.parse('${ApiConfig.baseUrl}/HoaDon/user/$userId');

    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return data;
      } else {
        throw Exception('Phản hồi không đúng định dạng danh sách: $data');
      }
    } else {
      throw Exception(
        'Không lấy được danh sách hóa đơn [${res.statusCode}]: ${res.body}',
      );
    }
  }
}
