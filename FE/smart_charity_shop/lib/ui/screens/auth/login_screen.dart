import 'package:flutter/material.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
import 'package:smart_charity_shop/services/google_auth_service.dart';
import 'package:smart_charity_shop/theme/app_colors.dart';
import 'package:smart_charity_shop/theme/app_text_styles.dart';
import 'package:smart_charity_shop/ui/screens/auth/registration_screen.dart';
import 'package:smart_charity_shop/ui/screens/home_screen.dart';
import 'package:smart_charity_shop/ui/widgets/ui_kit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    if (_emailC.text.isEmpty || !_emailC.text.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email không hợp lệ")));
      return;
    }
    if (_passC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng nhập mật khẩu")));
      return;
    }
    final ok = await AuthService.login(_emailC.text.trim(), _passC.text);
    setState(() => _loading = false);

    if (ok && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 🌈 Header với gradient và icon
          Container(
            height: height * 0.36,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    "Chào mừng quay lại 👋",
                    style: AppTextStyles.h1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Đăng nhập để tiếp tục hành trình thiện nguyện của bạn",
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // 📄 Form Login
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Đăng nhập tài khoản",
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      AppTextField(
                        controller: _emailC,
                        hint: "you@example.com",
                        keyboardType: TextInputType.emailAddress,
                        prefix: const Icon(Icons.email_outlined),
                      ),
                      const SizedBox(height: 16),

                      // Password
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
                      const SizedBox(height: 20),

                      PrimaryButton(
                        label: "Đăng nhập",
                        icon: Icons.login_rounded,
                        loading: _loading,
                        onPressed: _handleLogin,
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Quên mật khẩu?",
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const _DividerText(text: "Hoặc"),
                      const SizedBox(height: 16),

                      OutlineButtonX(
                        label: "Đăng nhập bằng Google",
                        icon: Icons.g_mobiledata_rounded,
                        onPressed: () async {
                          setState(() => _loading = true);
                          final ok = await GoogleAuthService.signInWithGoogle();
                          setState(() => _loading = false);
                          if (ok && mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Đăng nhập Google thất bại"),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Chưa có tài khoản? ",
                              style: AppTextStyles.caption,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegistrationScreen(),
                                ),
                              ),
                              child: Text(
                                "Đăng ký ngay",
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ⏳ Overlay loading
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

class _DividerText extends StatelessWidget {
  const _DividerText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.8)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(text, style: AppTextStyles.caption),
        ),
        const Expanded(child: Divider(thickness: 0.8)),
      ],
    );
  }
}
