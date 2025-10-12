import 'package:flutter/material.dart';
import 'package:smart_charity_shop/ui/screens/donate_history_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'home_screen.dart';
//import 'donate_history_screen.dart'; // màn lịch sử quyên góp (bạn có thể tạo sau)

class DonateSuccessScreen extends StatelessWidget {
  const DonateSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 120,
              ),
              const SizedBox(height: 24),
              Text(
                "Cảm ơn bạn!",
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                "Giao dịch của bạn đã được xử lý thành công.\n"
                "Cảm ơn vì sự đóng góp ý nghĩa này ❤️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Nút về trang chủ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text("Về trang chủ"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: AppTextStyles.bodyBold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nút xem lịch sử quyên góp
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DonateHistoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: const Text("Xem lịch sử quyên góp"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: AppTextStyles.bodyBold,
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
