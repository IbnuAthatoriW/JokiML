import 'package:flutter/material.dart';
import 'package:jokiml_mobile/screens/auth_screen.dart';
import 'package:jokiml_mobile/screens/home_screen.dart';
import 'package:jokiml_mobile/services/api_service.dart';
import 'package:jokiml_mobile/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JokiML',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: AppColors.surfaceSoft,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Cek apakah user sudah login atau belum berdasarkan token tersimpan
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Delay singkat biar splash keliatan
    await Future.delayed(const Duration(seconds: 1));

    final api = ApiService();
    final token = await api.getToken();

    if (!mounted) return;

    if (token != null) {
      // Ada token, verifikasi ke server
      try {
        await api.getMe();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } catch (_) {
        // Token expired/invalid
        await api.clearToken();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                'JOKI ML',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 6,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mobile Legends Rank Booster',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: AppColors.secondary, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
