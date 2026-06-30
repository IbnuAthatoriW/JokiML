import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  late final Dio dio;

  // Ganti IP ini sesuai kebutuhan:
  // - HP fisik Android via USB (rekomendasi: jalankan 'adb reverse tcp:8000 tcp:8000') → http://127.0.0.1:8000/api
  // - HP fisik / Genymotion via Wi-Fi (IP PC saat ini: 192.168.0.120)                  → http://192.168.0.120:8000/api
  // - Emulator Android bawaan                                                          → http://10.0.2.2:8000/api
  // - Production                                                                       → https://domain-kamu.com/api
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  dynamic _decodeBody(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      throw Exception(
        'Invalid JSON response from server: ${body.length > 200 ? body.substring(0, 200) + "..." : body}',
      );
    }
  }

  // ─── TOKEN MANAGEMENT ─────────────────────────────────────────────────────

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── AUTH ──────────────────────────────────────────────────────────────────

  /// Login → simpan token, return user map
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = _decodeBody(response.body);
    if (response.statusCode == 200) {
      await saveToken(body['access_token']);
      return body['user'];
    }
    throw Exception(body['message'] ?? 'Login gagal');
  }

  /// Register → simpan token, return user map
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final body = _decodeBody(response.body);
    if (response.statusCode == 201) {
      await saveToken(body['access_token']);
      return body['user'];
    }
    throw Exception(body['message'] ?? 'Registrasi gagal');
  }

  /// Logout → hapus token
  Future<void> logout() async {
    final headers = await _authHeaders();
    await http.post(Uri.parse('$baseUrl/auth/logout'), headers: headers);
    await clearToken();
  }

  /// Ambil data user yang sedang login
  Future<Map<String, dynamic>> getMe() async {
    final headers = await _authHeaders();
    final response = await http.get(Uri.parse('$baseUrl/auth/me'), headers: headers);

    if (response.statusCode == 200) {
      return _decodeBody(response.body)['user'];
    }
    throw Exception('Sesi habis, silakan login ulang');
  }

  // ─── SETTINGS (HARGA PAKET) ────────────────────────────────────────────────

  /// Ambil harga paket dari SettingApiController
  /// Return: Map seperti { 'price_gm_epic': 60000, 'price_epic_legend': 100000, ... }
  Future<Map<String, dynamic>> getSettings() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/settings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return _decodeBody(response.body) as Map<String, dynamic>;
    }
    throw Exception('Gagal memuat harga paket');
  }

  // ─── ORDERS ────────────────────────────────────────────────────────────────

  /// Ambil daftar order milik user yang login
  Future<List<Map<String, dynamic>>> getMyOrders() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = _decodeBody(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat riwayat order');
  }

  /// Kirim order baru dengan bukti pembayaran (multipart/form-data)
  /// Backend butuh: type, price, customer_name, game_id,
  ///                moonton_account, moonton_password, whatsapp,
  ///                payment_proof (file gambar),
  ///                paket_name / from_rank / to_rank / from_star / to_star (opsional)
  Future<Map<String, dynamic>> createOrder({
    required String type, // 'paket' atau 'custom'
    required double price,
    required String customerName,
    required String gameId,
    required String moontoonAccount,
    required String moontoonPassword,
    required String whatsapp,
    required File paymentProof,
    String? paketName,
    String? fromRank,
    String? toRank,
    int? fromStar,
    int? toStar,
    String? heroRequest,
  }) async {
    final token = await getToken();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/orders'));

    // Headers
    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    // Field teks
    request.fields['type'] = type;
    request.fields['price'] = price.toStringAsFixed(0);
    request.fields['customer_name'] = customerName;
    request.fields['game_id'] = gameId;
    request.fields['moonton_account'] = moontoonAccount;
    request.fields['moonton_password'] = moontoonPassword;
    request.fields['whatsapp'] = whatsapp;
    if (paketName != null) request.fields['paket_name'] = paketName;
    if (fromRank != null) request.fields['from_rank'] = fromRank;
    if (toRank != null) request.fields['to_rank'] = toRank;
    if (fromStar != null) request.fields['from_star'] = fromStar.toString();
    if (toStar != null) request.fields['to_star'] = toStar.toString();
    if (heroRequest != null) request.fields['hero_request'] = heroRequest;

    // File bukti pembayaran
    request.files.add(
      await http.MultipartFile.fromPath('payment_proof', paymentProof.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = _decodeBody(response.body);

    if (response.statusCode == 201) {
      return body['order'];
    }
    // Tampilkan error validasi dari Laravel
    if (body['errors'] != null) {
      final errors = body['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      throw Exception(firstError is List ? firstError.first : firstError);
    }
    throw Exception(body['message'] ?? 'Gagal membuat order');
  }

  // ─── TESTIMONIALS ──────────────────────────────────────────────────────────

  /// Ambil daftar testimonial
  Future<List<Map<String, dynamic>>> getTestimonials() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/testimonials'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = _decodeBody(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal memuat testimonial');
  }

  /// Kirim testimonial baru
  Future<Map<String, dynamic>> submitTestimonial({
    required String content,
    required int rating,
  }) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/testimonials'),
      headers: headers,
      body: jsonEncode({'content': content, 'rating': rating}),
    );

    final body = _decodeBody(response.body);
    if (response.statusCode == 201) {
      return body['testimonial'];
    }
    throw Exception(body['message'] ?? 'Gagal mengirim testimonial');
  }

  /// Hapus testimonial
  Future<void> deleteTestimonial(int id) async {
    final headers = await _authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/testimonials/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final body = _decodeBody(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus testimonial');
    }
  }
}
