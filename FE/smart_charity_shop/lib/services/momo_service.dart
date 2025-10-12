import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class MomoService {
  static const String endpoint =
      "https://test-payment.momo.vn/v2/gateway/api/create";

  static const String partnerCode = "MOMO";
  static const String accessKey = "F8BBA842ECF85";
  static const String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
  static const String redirectUrl = "smartcharity://payment/momo_result";

  static const String ipnUrl = "https://flutter.dev";

  static Future<String?> createPayment({
    int? campaignId,
    int? idOrder,
    required double amount,
    String type = "donate", // "donate" | "order"
  }) async {
    final orderId = "ORDER_${DateTime.now().millisecondsSinceEpoch}";
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    final orderInfo = type == "donate"
        ? "Donate campaign $campaignId"
        : "Pay order $idOrder";

    // 🧩 Gói extraData theo loại giao dịch
    final Map<String, dynamic> extraJson = {
      "type": type,
      "id": type == "donate" ? campaignId : idOrder,
    };
    final extraData = base64.encode(utf8.encode(jsonEncode(extraJson)));

    // ✅ Chuỗi ký để tạo chữ ký
    final rawHash =
        "accessKey=$accessKey&amount=${amount.toInt()}&extraData=$extraData"
        "&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo"
        "&partnerCode=$partnerCode&redirectUrl=$redirectUrl"
        "&requestId=$requestId&requestType=captureWallet";

    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final signature = hmac.convert(utf8.encode(rawHash)).toString();

    final body = {
      "partnerCode": partnerCode,
      "partnerName": "MoMo",
      "storeId": "SmartCharity",
      "requestType": "captureWallet",
      "ipnUrl": ipnUrl,
      "redirectUrl": redirectUrl,
      "orderId": orderId,
      "amount": amount.toInt(),
      "lang": "vi",
      "orderInfo": orderInfo,
      "requestId": requestId,
      "extraData": extraData,
      "signature": signature,
    };

    final res = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print("🟣 MoMo response: $data");
      if (data["resultCode"] == 0) {
        return data["deeplink"] ?? data["payUrl"];
      }
    }

    print("🔴 MoMo HTTP failed: ${res.body}");
    return null;
  }

  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    print("🔗 Opening MoMo deeplink: $uri");

    // Mở app MoMo
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );

    // Nếu không mở được app thì fallback sang web
    if (!launched) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
