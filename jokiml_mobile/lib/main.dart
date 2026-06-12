import 'package:flutter/material.dart';
// Mengambil file home_screen yang baru saja Anda buat
import 'package:jokiml_mobile/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JokiML Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Segoe UI', // Biar font-nya elegan mirip web
        scaffoldBackgroundColor: const Color(
          0xFF050508,
        ), // Warna latar belakang web
      ),
      home: const HomeScreen(), // Mengarahkan ke tampilan Hero web Anda
    );
  }
}
