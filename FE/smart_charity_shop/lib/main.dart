import 'package:flutter/material.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
import 'package:smart_charity_shop/state/cart_provider.dart';
import 'package:smart_charity_shop/ui/screens/auth/login_screen.dart';
import 'package:smart_charity_shop/ui/screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cart = CartProvider();
  await cart.load();
  runApp(
    ChangeNotifierProvider(create: (_) => cart, child: const SmartCharityApp()),
  );
}

class SmartCharityApp extends StatelessWidget {
  const SmartCharityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Charity Shop",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});
  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await AuthService.isLoggedIn();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
