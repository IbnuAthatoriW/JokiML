import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Ganti localhost dengan IP Laptop Anda (Contoh: 192.168.1.X) jika ditest pake HP asli
  // atau pakai http://10.0.2.2:8000 jika ditest pake Emulator Android bawaan laptop.
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // 1. Ambil Data Paket Joki dari SettingApiController Laravel
  Future<List<Map<String, dynamic>>> getPaketJoki() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/settings'),
      ); // Sesuaikan route API Anda

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Gagal memuat paket joki dari web');
      }
    } catch (e) {
      throw Exception('Error Koneksi: $e');
    }
  }

  // 2. Kirim Data Orderan Baru ke OrderApiController Laravel
  Future<bool> kirimOrder({
    required String idGame,
    required String zoneId,
    required int paketId,
    required String nomorWa,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'), // Menembak ke OrderApiController.php
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_game': idGame,
          'zone_id': zoneId,
          'paket_id': paketId,
          'nomor_wa': nomorWa,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 21) {
        return true; // Berhasil disimpan ke database web
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
