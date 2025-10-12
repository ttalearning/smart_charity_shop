import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_charity_shop/services/momo_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/donation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateScreen extends StatefulWidget {
  final int campaignId;
  const DonateScreen({super.key, required this.campaignId});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final _amountCtrl = TextEditingController();
  final _messageCtrl =
      TextEditingController(); // ✅ Thêm controller cho lời nhắn
  String? _selectedMethod;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _messageCtrl.dispose(); // ✅ dispose controller mới
    super.dispose();
  }

  Future<void> _submit() async {
    final amountText = _amountCtrl.text.trim();
    if (amountText.isEmpty) {
      _showSnack("Vui lòng nhập số tiền muốn quyên góp.");
      return;
    }

    final amount = double.tryParse(amountText.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      _showSnack("Số tiền không hợp lệ.");
      return;
    }

    if (_selectedMethod == null) {
      _showSnack("Vui lòng chọn phương thức thanh toán.");
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_donation_amount', amount);
    await prefs.setInt('last_campaign_id', widget.campaignId);
    await prefs.setString('last_message', _messageCtrl.text.trim());

    try {
      final momoUrl = await MomoService.createPayment(
        campaignId: widget.campaignId,
        amount: amount,
        type: "donate",
      );

      setState(() => _isLoading = false);

      if (momoUrl == null) {
        _showSnack("Không tạo được giao dịch MoMo.");
        return;
      }

      final uri = Uri.parse(momoUrl);
      print("🔗 Opening MoMo deeplink: $uri");

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack("Lỗi: $e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Quyên góp"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nhập số tiền muốn quyên góp", style: AppTextStyles.h3),
              const SizedBox(height: 12),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: "₫ ",
                  hintText: "Ví dụ: 100000",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Lời nhắn cho chiến dịch (tuỳ chọn)",
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Ví dụ: Gửi tặng các em nhỏ vùng cao ❤️",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text("Chọn phương thức thanh toán", style: AppTextStyles.h3),
              const SizedBox(height: 12),

              _buildPaymentOption(
                "MoMo",
                "https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png",
              ),
              _buildPaymentOption(
                "VNPay",
                "https://cdn-new.topcv.vn/unsafe/https://static.topcv.vn/company_logos/cong-ty-cp-giai-phap-thanh-toan-viet-nam-vnpay-6194ba1fa3d66.jpg",
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.volunteer_activism_rounded),
                  label: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Xác nhận quyên góp"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: AppTextStyles.bodyBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method, String logoUrl) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.network(logoUrl, height: 40),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
