import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/ApiConfig.dart';
import '../models/campaign_model.dart';

class CampaignService {
  static Future<List<Campaign>> fetchAll() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Campaign.fromJson(e)).toList();
    } else {
      throw Exception(
        "Không tải được danh sách chiến dịch (${res.statusCode})",
      );
    }
  }

  static Future<List<Campaign>> fetchFeatured() async {
    final all = await fetchAll();
    all.sort((a, b) => b.progress.compareTo(a.progress));
    return all.take(4).toList();
  }

  /// 🔵 Lấy chi tiết chiến dịch theo ID
  static Future<Campaign> fetchById(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich/$id");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return Campaign.fromJson(data);
    } else {
      throw Exception("Không tìm thấy chiến dịch #$id");
    }
  }

  /// 🔒 Admin - tạo chiến dịch
  static Future<bool> create(Map<String, dynamic> dto, String token) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich");
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto),
    );
    return res.statusCode == 201;
  }

  /// 🔒 Admin - cập nhật
  static Future<bool> update(
    int id,
    Map<String, dynamic> dto,
    String token,
  ) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich/$id");
    final res = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto),
    );
    return res.statusCode == 204;
  }

  /// 🔒 Admin - xóa
  static Future<bool> delete(int id, String token) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich/$id");
    final res = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return res.statusCode == 204;
  }

  static Future<bool> addImages(int id, List<String> urls, String token) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/ChienDich/$id/images");
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(urls),
    );
    return res.statusCode == 200;
  }
}
