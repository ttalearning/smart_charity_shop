import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/ApiConfig.dart';
import '../models/donation_model.dart';
import '../models/top_donation_model.dart';

class DonationService {
  static Future<List<Donation>> fetchByCampaign(int campaignId) async {
    final url = Uri.parse(
      "${ApiConfig.baseUrl}/DongGop/by-campaign/$campaignId",
    );
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Donation.fromJson(e)).toList();
    } else {
      throw Exception("Không tải được danh sách đóng góp (${res.statusCode})");
    }
  }

  static Future<bool> create({
    required int campaignId,
    required double amount,
    required String token,
  }) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/DongGop/create");
    final body = jsonEncode({"chienDichId": campaignId, "soTien": amount});

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (res.statusCode == 401) {
      throw Exception(
        "Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.",
      );
    }

    return res.statusCode == 201;
  }

  static Future<List<TopDonation>> fetchTopDonors() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/DongGop/top");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => TopDonation.fromJson(e)).toList();
    } else {
      throw Exception("Không tải được danh sách top donor (${res.statusCode})");
    }
  }

  static Future<List<dynamic>> fetchMyDonations(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        print("hông tìm thấy token người dùng.");
        return [];
      }

      final url = Uri.parse("${ApiConfig.baseUrl}/DongGop/$userId");
      print("📡 Fetching donations for userId=$userId ...");

      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print("✅ Nhận ${data.length} donations");
        return data is List ? data : [];
      } else {
        print("🔴 Lỗi API DongGop/$userId: ${res.statusCode} - ${res.body}");
        return [];
      }
    } catch (e) {
      print("🔥 Lỗi fetchMyDonations(): $e");
      return [];
    }
  }
}
