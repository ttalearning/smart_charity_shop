import 'package:flutter/material.dart';
import 'package:smart_charity_shop/ui/widgets/ui_kit.dart';
import '/../services/auth_service.dart';
import '/../theme/app_colors.dart';
import '/../theme/app_text_styles.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String email = "";
  String role = "";
  String? avatar;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.getUserInfo();
    setState(() {
      name = data['name'];
      email = data['email'];
      role = data['role'];
      avatar = data['avatar'];
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Smart Charity Shop"),
        backgroundColor: AppColors.surface,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (avatar != null && avatar!.isNotEmpty)
                CircleAvatar(radius: 45, backgroundImage: NetworkImage(avatar!))
              else
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 40),
                ),
              const SizedBox(height: 16),
              Text("Xin chào, $name 👋", style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(email, style: AppTextStyles.caption),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Vai trò: $role",
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: "Đăng xuất",
                icon: Icons.logout_rounded,
                onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
