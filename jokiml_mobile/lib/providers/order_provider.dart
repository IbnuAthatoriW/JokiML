// lib/providers/order_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  // Fetch orders (admin sees all, user sees their own)
  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/orders');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _orders = data.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new order
  Future<Map<String, dynamic>> createOrder({
    required String type,
    required double price,
    String? paketName,
    String? fromRank,
    String? toRank,
    int? fromStar,
    int? toStar,
    required String customerName,
    required String gameId,
    required String moontonAccount,
    required String moontonPassword,
    String? heroRequest,
    required String whatsapp,
    required String filePath,
    bool isWeb = false,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Define text fields
      final Map<String, String> fields = {
        'type': type,
        'price': price.toInt().toString(),
        'customer_name': customerName,
        'game_id': gameId,
        'moonton_account': moontonAccount,
        'moonton_password': moontonPassword,
        'whatsapp': whatsapp,
      };

      if (paketName != null) fields['paket_name'] = paketName;
      if (fromRank != null) fields['from_rank'] = fromRank;
      if (toRank != null) fields['to_rank'] = toRank;
      if (fromStar != null) fields['from_star'] = fromStar.toString();
      if (toStar != null) fields['to_star'] = toStar.toString();
      if (heroRequest != null && heroRequest.isNotEmpty) {
        fields['hero_request'] = heroRequest;
      }

      final response = await ApiService.postMultipart(
        endpoint: '/orders',
        fields: fields,
        fileField: 'payment_proof',
        filePath: filePath,
        isWeb: isWeb,
        fileBytes: fileBytes,
        fileName: fileName,
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final newOrder = OrderModel.fromJson(data['order']);
        _orders.insert(0, newOrder);
        return {'success': true, 'order': newOrder};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed to submit order'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update order status (Admin only)
  Future<bool> updateOrderStatus(int orderId, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.patch('/orders/$orderId/status', {
        'status': status,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final updatedOrder = OrderModel.fromJson(data['order']);

        // Update local state list
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          _orders[index] = updatedOrder;
        }
        return true;
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
