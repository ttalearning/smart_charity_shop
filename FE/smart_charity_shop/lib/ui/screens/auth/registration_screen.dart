import 'package:flutter/material.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  int _roleIndex = 0;

  bool _loading = false;
  bool _obscure = true;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

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
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đăng ký thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0.2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tạo tài khoản mới", style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(
                "Hãy bắt đầu hành trình thiện nguyện cùng chúng tôi.",
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 24),

              Text("Họ và tên", style: AppTextStyles.bodyBold),
              const SizedBox(height: 8),
              AppTextField(controller: _nameC, hint: "Nguyễn Văn A"),
              const SizedBox(height: 16),

              Text("Email", style: AppTextStyles.bodyBold),
              const SizedBox(height: 8),
              AppTextField(
                controller: _emailC,
                hint: "you@example.com",
                keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 20),

              PrimaryButton(
                label: "Đăng ký ngay",
                icon: Icons.person_add_alt_1_rounded,
                loading: _loading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
