import 'package:flutter/material.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
import 'package:smart_charity_shop/services/google_auth_service.dart';
import '/../../theme/app_colors.dart';
import '/../../theme/app_text_styles.dart';
import '../../widgets/ui_kit.dart';
import '../home_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _handleLogin() async {
    if (_emailC.text.isEmpty || _passC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ thông tin")),
      );
      return;
    }
    setState(() => _loading = true);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        centerTitle: true,
        elevation: 0.2,
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Chào mừng quay lại 👋", style: AppTextStyles.h2),
            const SizedBox(height: 6),
            Text(
              "Đăng nhập để tiếp tục hành trình thiện nguyện của bạn.",
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),

            Text("Email", style: AppTextStyles.bodyBold),
            const SizedBox(height: 8),
            AppTextField(
              controller: _emailC,
              hint: "you@example.com",
              keyboardType: TextInputType.emailAddress,
              prefix: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 16),

            Text("Mật khẩu", style: AppTextStyles.bodyBold),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),

            PrimaryButton(
              label: "Đăng nhập",
              icon: Icons.login_rounded,
              loading: _loading,
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 20),
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
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đăng nhập Google thất bại")),
                  );
                }
              },
            ),
            Center(child: _DividerText(text: "Hoặc")),
            const SizedBox(height: 16),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text("Chưa có tài khoản? ", style: AppTextStyles.caption),
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
