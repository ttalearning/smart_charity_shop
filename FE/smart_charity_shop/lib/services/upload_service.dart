import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';

class UploadService {
  /// type: "product" hoặc "campaign"
  static Future<String?> uploadImage(
    File file, {
    String type = "product",
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/Upload/$type');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return data["url"];
      } else {
        print('Upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
