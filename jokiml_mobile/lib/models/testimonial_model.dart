// lib/models/testimonial_model.dart
import 'user_model.dart';

class TestimonialModel {
  final int id;
  final int userId;
  final String content;
  final int rating;
  final String? reply;
  final String createdAt;
  final UserModel? user;

  TestimonialModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.rating,
    this.reply,
    required this.createdAt,
    this.user,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      content: json['content'] ?? '',
      rating: json['rating'] is String ? int.parse(json['rating']) : (json['rating'] ?? 5),
      reply: json['reply'],
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'rating': rating,
      'reply': reply,
      'created_at': createdAt,
    };
  }
}
