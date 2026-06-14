import 'package:flutter/material.dart';
import 'package:jokiml_mobile/screens/auth_screen.dart';
import 'package:jokiml_mobile/screens/home_screen.dart';
import 'package:jokiml_mobile/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JokiML',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050508),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00FFCC),
          surface: const Color(0xFF0F172A),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

/// Cek apakah user sudah login atau belum berdasarkan token tersimpan
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
    return const Scaffold(
      backgroundColor: Color(0xFF050508),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JOKI ML',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00FFCC),
                letterSpacing: 6,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Mobile Legends Rank Booster',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Color(0xFF00FFCC), strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
