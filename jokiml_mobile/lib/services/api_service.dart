// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Use http://10.0.2.2/api for Android emulator, http://localhost/api for desktop/web
  // We'll expose it as static and modifiable
  static String baseUrl = 'http://localhost/api';

  static Future<Map<String, String>> _getHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // GET Request
  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return response;
  }

  // POST Request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }

  // DELETE Request
  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return response;
  }

  // PATCH Request
  static Future<http.Response> patch(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }

  // POST Multipart Request (For Order creation with image upload)
  static Future<http.Response> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
    bool isWeb = false,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // Get Auth Headers
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    request.headers['Accept'] = 'application/json';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add text fields
    request.fields.addAll(fields);

    // Add image file
    if (isWeb && fileBytes != null && fileName != null) {
      // For Flutter Web
      final multipartFile = http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: fileName,
        contentType: MediaType('image', fileName.split('.').last),
      );
      request.files.add(multipartFile);
    } else {
      // For Mobile / Desktop
      final file = File(filePath);
      if (await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath(
          fileField,
          filePath,
          contentType: MediaType('image', filePath.split('.').last),
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
