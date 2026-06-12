// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  bool get isAdmin => _user?.isAdmin ?? false;

  AuthProvider() {
    loadCachedSession();
  }

  // Load token and user session on startup
  Future<void> loadCachedSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('access_token');
      final String? userJson = prefs.getString('cached_user');
      
      if (_token != null && userJson != null) {
        _user = UserModel.fromJson(jsonDecode(userJson));
        
        // Asynchronously refresh the user profile in the background
        refreshUserProfile();
      }
    } catch (e) {
      debugPrint('Error loading cached session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh user data from API
  Future<void> refreshUserProfile() async {
    try {
      final response = await ApiService.get('/auth/me');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _user = UserModel.fromJson(data['user']);
        
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_user', jsonEncode(_user!.toJson()));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing user profile: $e');
    }
  }

  // Handle User Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = body['access_token'];
        _user = UserModel.fromJson(body['user']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', _token!);
        await prefs.setString('cached_user', jsonEncode(_user!.toJson()));

        return {'success': true, 'message': 'Success'};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Handle User Registration
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? authentifikasi,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> payload = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      if (authentifikasi != null && authentifikasi.isNotEmpty) {
        payload['authentifikasi'] = authentifikasi;
      }

      final response = await ApiService.post('/auth/register', payload);
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _token = body['access_token'];
        _user = UserModel.fromJson(body['user']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', _token!);
        await prefs.setString('cached_user', jsonEncode(_user!.toJson()));

        return {'success': true, 'message': 'Success'};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Handle User Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call API logout (will revoke current Sanctum token)
      await ApiService.post('/auth/logout', {});
    } catch (e) {
      debugPrint('Logout error (already expired/revoked server side): $e');
    } finally {
      // Clear local cache regardless of API success/failure
      _token = null;
      _user = null;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('cached_user');
      
      _isLoading = false;
      notifyListeners();
    }
  }
}
