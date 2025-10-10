import 'dart:convert';
import 'package:http/http.dart' as http;
import '/../configs/ApiConfig.dart';
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

  /// GET /api/SanPham/ByLoai/{loaiId} (nếu bạn đã thêm ở BE)
  static Future<List<Product>> fetchByLoai(int loaiId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/SanPham/ByLoai/$loaiId');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Không tải được theo loại (${res.statusCode})');
  }

  /// Tìm kiếm (nếu chưa có endpoint → filter client)
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
