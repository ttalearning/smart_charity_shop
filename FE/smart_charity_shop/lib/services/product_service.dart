import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';
import '/../models/product_model.dart';

class ProductService {
  /// GET /api/SanPham
  static Future<List<Product>> fetchAll() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/SanPham');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Không tải được sản phẩm (${res.statusCode})');
  }

  static Future<List<Product>> fetchByLoai(int categoryId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/SanPham/by-category/$categoryId',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Không tải được theo loại (${res.statusCode})');
  }

  static Future<bool> create(Map<String, dynamic> data, String token) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/SanPham');

    final payload = {
      "tenSanPham": data["tenSanPham"],
      "gia": data["gia"],
      "moTa": data["moTa"],
      "anhChinh": data["anhChinh"],
      "loaiId": data["loaiId"],
      "hinhAnhs":
          (data["hinhAnhs"] as List<dynamic>?)
              ?.map((url) => {"url": url, "isChinh": false})
              .toList() ??
          [],
    };

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<bool> update(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/SanPham/$id');

    final payload = {
      "tenSanPham": data["tenSanPham"],
      "gia": data["gia"],
      "moTa": data["moTa"],
      "anhChinh": data["anhChinh"],
      "loaiId": data["loaiId"],
      "hinhAnhs":
          (data["hinhAnhs"] as List<dynamic>?)
              ?.map((url) => {"url": url, "isChinh": false})
              .toList() ??
          [],
    };

    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload),
    );

    return res.statusCode == 200 || res.statusCode == 204;
  }

  static Future<bool> delete(int id, String token) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/SanPham/$id');

    final res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return res.statusCode == 200 || res.statusCode == 204;
  }

  static List<Product> searchLocal(List<Product> all, String q) {
    final query = q.toLowerCase();
    return all
        .where(
          (p) =>
              p.tenSanPham.toLowerCase().contains(query) ||
              (p.tenLoai ?? '').toLowerCase().contains(query),
        )
        .toList();
  }
}
