import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/ApiConfig.dart';
import '../models/category_model.dart';

class CategoryService {
  /// GET /api/LoaiSanPham
  static Future<List<Category>> fetchAll() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/LoaiSanPham');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Không tải được loại sản phẩm (${res.statusCode})');
  }

  /// GET /api/LoaiSanPham/{id}
  static Future<Category> fetchById(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/LoaiSanPham/$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return Category.fromJson(jsonDecode(res.body));
    }
    throw Exception('Không tìm thấy loại #$id');
  }

  // ====== Admin (tuỳ dùng) ======
  static Future<bool> create(
    String tenLoai, {
    bool isActive = true,
    required String token,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/LoaiSanPham');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'tenLoai': tenLoai, 'isActive': isActive}),
    );
    return res.statusCode == 201;
  }

  static Future<bool> update(
    int id,
    String tenLoai, {
    bool isActive = true,
    required String token,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/LoaiSanPham/$id');
    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'tenLoai': tenLoai, 'isActive': isActive}),
    );
    return res.statusCode == 204;
  }

  static Future<bool> delete(int id, {required String token}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/LoaiSanPham/$id');
    final res = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return res.statusCode == 204;
  }
}
