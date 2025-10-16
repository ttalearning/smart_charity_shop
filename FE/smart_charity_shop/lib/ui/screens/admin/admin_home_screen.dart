import 'package:flutter/material.dart';
import 'package:smart_charity_shop/ui/screens/admin/campaign_admin_screen.dart';
import 'package:smart_charity_shop/ui/screens/admin/category_admin_screen.dart';
import 'package:smart_charity_shop/ui/screens/admin/product_admin_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bảng điều khiển Admin"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quản lý hệ thống",
              style: AppTextStyles.h1.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 20),

            /// --- 3 NÚT QUẢN LÝ ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAdminCard(
                  context,
                  icon: Icons.shopping_bag,
                  title: "Sản phẩm",
                  color: Colors.blue.shade100,
                  screen: const ProductAdminScreen(),
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.category,
                  title: "Danh mục",
                  color: Colors.green.shade100,
                  screen: const ProductAdminScreen(),
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.campaign,
                  title: "Chiến dịch",
                  color: Colors.orange.shade100,
                  screen: const CampaignAdminScreen(),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// --- CHARTS SECTION (để sau) ---
            Text(
              "Biểu đồ thống kê",
              style: AppTextStyles.h2.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "📊 Khu vực hiển thị biểu đồ (sẽ thêm sau)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget phụ tạo từng card admin
  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: AppColors.primary),
              const SizedBox(height: 10),
              Text(title, style: AppTextStyles.h3),
            ],
          ),
        ),
      ),
    );
  }
}
