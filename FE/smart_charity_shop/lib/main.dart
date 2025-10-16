import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_charity_shop/services/auth_service.dart';
import 'package:smart_charity_shop/state/cart_provider.dart';
import 'package:smart_charity_shop/ui/screens/auth/login_screen.dart';
import 'package:smart_charity_shop/ui/screens/home_screen.dart';
import 'package:smart_charity_shop/ui/screens/splash_screen.dart';
import 'package:smart_charity_shop/utils/momo_callback_handler.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cart = CartProvider();
  await cart.load();

  runApp(
    ChangeNotifierProvider(create: (_) => cart, child: const SmartCharityApp()),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      MomoCallbackHandler.initListener(ctx);
    } else {
      debugPrint("MoMo listener: context chưa sẵn sàng");
    }
  });
}

class SmartCharityApp extends StatelessWidget {
  const SmartCharityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Smart Charity Shop",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
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
    await Future.delayed(const Duration(milliseconds: 800));
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            loggedIn ? const HomeScreen() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
