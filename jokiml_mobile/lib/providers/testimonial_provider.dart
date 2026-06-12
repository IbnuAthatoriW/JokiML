// lib/providers/testimonial_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/testimonial_model.dart';
import '../services/api_service.dart';

class TestimonialProvider extends ChangeNotifier {
  List<TestimonialModel> _testimonials = [];
  bool _isLoading = false;

  List<TestimonialModel> get testimonials => _testimonials;
  bool get isLoading => _isLoading;

  Future<void> fetchTestimonials() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/testimonials');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _testimonials = data.map((json) => TestimonialModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching testimonials: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit new review
  Future<bool> addTestimonial(String content, int rating) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/testimonials', {
        'content': content,
        'rating': rating,
      });

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final newTestimonial = TestimonialModel.fromJson(data['testimonial']);
        _testimonials.insert(0, newTestimonial);
        return true;
      }
    } catch (e) {
      debugPrint('Error adding testimonial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Delete testimonial (user own or admin)
  Future<bool> deleteTestimonial(int testimonialId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.delete('/testimonials/$testimonialId');
      if (response.statusCode == 200) {
        _testimonials.removeWhere((t) => t.id == testimonialId);
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting testimonial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Admin reply to testimonial
  Future<bool> replyTestimonial(int testimonialId, String replyText) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/testimonials/$testimonialId/reply', {
        'reply': replyText,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final updatedTestimonial = TestimonialModel.fromJson(data['testimonial']);

        // Update local state list
        final index = _testimonials.indexWhere((t) => t.id == testimonialId);
        if (index != -1) {
          _testimonials[index] = updatedTestimonial;
        }
        return true;
      }
    } catch (e) {
      debugPrint('Error replying to testimonial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
