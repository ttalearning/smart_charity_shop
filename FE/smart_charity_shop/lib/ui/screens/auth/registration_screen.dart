import 'package:flutter/material.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
import 'package:smart_charity_shop/ui/screens/auth/login_screen.dart';
import '/../../theme/app_colors.dart';
import '/../../theme/app_text_styles.dart';
import '../../widgets/ui_kit.dart';
import '../home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _handleRegister() async {
    if (_nameC.text.trim().isEmpty) {
      _showSnack("Vui lòng nhập họ và tên");
      return;
    }
    if (_emailC.text.trim().isEmpty || !_emailC.text.contains('@')) {
      _showSnack("Email không hợp lệ");
      return;
    }
    if (_passC.text.trim().length < 6) {
      _showSnack("Mật khẩu phải có ít nhất 6 ký tự");
      return;
    }

    setState(() => _loading = true);
    final ok = await AuthService.register(
      name: _nameC.text.trim(),
      email: _emailC.text.trim(),
      password: _passC.text.trim(),
      role: "User",
    );
    setState(() => _loading = false);

    if (ok && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } else {
      _showSnack("Đăng ký thất bại. Vui lòng thử lại!");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 🌈 Header Gradient
          Container(
            height: height * 0.32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    "Tạo tài khoản mới 💫",
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Hãy bắt đầu hành trình thiện nguyện cùng chúng tôi",
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // 🧾 Form Đăng ký
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Container(
                margin: const EdgeInsets.only(top: 200),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    Text(
                      "Đăng ký tài khoản",
                      style: AppTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Họ và tên
                    AppTextField(
                      controller: _nameC,
                      hint: "Nguyễn Văn A",
                      prefix: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AppTextField(
                      controller: _emailC,
                      hint: "you@example.com",
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),

                    // Mật khẩu
                    AppTextField(
                      controller: _passC,
                      hint: "••••••••",
                      obscure: _obscure,
                      prefix: const Icon(Icons.lock_outline),
                      suffix: IconButtonCircle(
                        icon: _obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        onTap: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nút Đăng ký
                    PrimaryButton(
                      label: "Đăng ký ngay",
                      icon: Icons.person_add_alt_1_rounded,
                      loading: _loading,
                      onPressed: _handleRegister,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Đã có tài khoản? ", style: AppTextStyles.caption),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Đăng nhập",
                            style: AppTextStyles.bodyBold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ⏳ Overlay loading
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.25),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
