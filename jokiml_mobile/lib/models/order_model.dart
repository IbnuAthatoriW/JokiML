// lib/models/order_model.dart
import 'user_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final String type;
  final String? paketName;
  final String? fromRank;
  final String? toRank;
  final int? fromStar;
  final int? toStar;
  final int price;
  final String status;
  final String paymentStatus;
  final String? paymentProof;
  final String customerName;
  final String gameId;
  final String moontonAccount;
  final String moontonPassword;
  final String? heroRequest;
  final String whatsapp;
  final String createdAt;
  final UserModel? user;

  OrderModel({
    required this.id,
    required this.userId,
    required this.type,
    this.paketName,
    this.fromRank,
    this.toRank,
    this.fromStar,
    this.toStar,
    required this.price,
    required this.status,
    required this.paymentStatus,
    this.paymentProof,
    required this.customerName,
    required this.gameId,
    required this.moontonAccount,
    required this.moontonPassword,
    this.heroRequest,
    required this.whatsapp,
    required this.createdAt,
    this.user,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      type: json['type'] ?? 'paket',
      paketName: json['paket_name'],
      fromRank: json['from_rank'],
      toRank: json['to_rank'],
      fromStar: json['from_star'] != null ? (json['from_star'] is String ? int.parse(json['from_star']) : json['from_star']) : null,
      toStar: json['to_star'] != null ? (json['to_star'] is String ? int.parse(json['to_star']) : json['to_star']) : null,
      price: json['price'] is String ? int.parse(json['price']) : (json['price'] ?? 0),
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paymentProof: json['payment_proof'],
      customerName: json['customer_name'] ?? '',
      gameId: json['game_id'] ?? '',
      moontonAccount: json['moonton_account'] ?? '',
      moontonPassword: json['moonton_password'] ?? '',
      heroRequest: json['hero_request'],
      whatsapp: json['whatsapp'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'paket_name': paketName,
      'from_rank': fromRank,
      'to_rank': toRank,
      'from_star': fromStar,
      'to_star': toStar,
      'price': price,
      'status': status,
      'payment_status': paymentStatus,
      'payment_proof': paymentProof,
      'customer_name': customerName,
      'game_id': gameId,
      'moonton_account': moontonAccount,
      'moonton_password': moontonPassword,
      'hero_request': heroRequest,
      'whatsapp': whatsapp,
      'created_at': createdAt,
    };
  }
}
