// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:smart_charity_shop/theme/app_colors.dart';
import 'package:smart_charity_shop/ui/screens/campaign_list_screen.dart';
import 'package:smart_charity_shop/ui/screens/donate_history_screen.dart';
import 'package:smart_charity_shop/ui/screens/home_screen.dart';
import 'package:smart_charity_shop/ui/screens/marketplace_screen.dart';
import 'package:smart_charity_shop/ui/screens/profile_screen.dart';
import 'package:smart_charity_shop/ui/widgets/page_transition.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNav({super.key, required this.currentIndex, this.onTap});

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, pageTransition(const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          pageTransition(const MarketplaceScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          pageTransition(const CampaignListScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          pageTransition(const ProfileScreen()),
        );
        break;
    }
    onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FBFD), Color(0xFFEAF5F2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary.withOpacity(0.6),
              currentIndex: currentIndex,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              onTap: (index) => _go(context, index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Trang chủ",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.storefront_rounded),
                  label: "Mua Sắm",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.campaign_rounded),
                  label: "Chiến dịch",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: "Cá nhân",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
