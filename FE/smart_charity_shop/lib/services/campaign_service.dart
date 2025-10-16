import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';
import '../models/campaign_model.dart';

class CampaignService {
  static Future<List<Campaign>> fetchAll() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ChienDich'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Campaign.fromJson(json)).toList();
      }
      print('Error fetching campaigns: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error fetching campaigns: $e');
      return [];
    }
  }

  static Future<List<Campaign>> fetchFeatured() async {
    final all = await fetchAll();
    all.sort((a, b) => b.progress.compareTo(a.progress));
    return all.take(4).toList();
  }

  static Future<Campaign?> fetchById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/chiendich/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Campaign.fromJson(data);
      }
      print('Error fetching campaign: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching campaign: $e');
      return null;
    }
  }

  static Future<bool> create(Map<String, dynamic> data, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/chiendich'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating campaign: $e');
      return false;
    }
  }

  static Future<bool> update(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/chiendich/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating campaign: $e');
      return false;
    }
  }

  static Future<bool> delete(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/chiendich/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting campaign: $e');
      return false;
    }
  }
}
