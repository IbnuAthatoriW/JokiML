// lib/providers/setting_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/setting_model.dart';
import '../services/api_service.dart';

class RankInfo {
  final String id;
  final String name;
  final String tier;
  final int order;
  final int maxStar;
  final bool freeInput;

  RankInfo({
    required this.id,
    required this.name,
    required this.tier,
    required this.order,
    required this.maxStar,
    required this.freeInput,
  });
}

class SettingProvider extends ChangeNotifier {
  SettingModel? _settings;
  bool _isLoading = false;

  SettingModel? get settings => _settings;
  bool get isLoading => _isLoading;

  final List<RankInfo> ranks = [
    RankInfo(id: 'epic5', name: 'Epic V', tier: 'epic', order: 1, maxStar: 5, freeInput: false),
    RankInfo(id: 'epic4', name: 'Epic IV', tier: 'epic', order: 2, maxStar: 5, freeInput: false),
    RankInfo(id: 'epic3', name: 'Epic III', tier: 'epic', order: 3, maxStar: 5, freeInput: false),
    RankInfo(id: 'epic2', name: 'Epic II', tier: 'epic', order: 4, maxStar: 5, freeInput: false),
    RankInfo(id: 'epic1', name: 'Epic I', tier: 'epic', order: 5, maxStar: 5, freeInput: false),
    RankInfo(id: 'legend5', name: 'Legend V', tier: 'legend', order: 6, maxStar: 5, freeInput: false),
    RankInfo(id: 'legend4', name: 'Legend IV', tier: 'legend', order: 7, maxStar: 5, freeInput: false),
    RankInfo(id: 'legend3', name: 'Legend III', tier: 'legend', order: 8, maxStar: 5, freeInput: false),
    RankInfo(id: 'legend2', name: 'Legend II', tier: 'legend', order: 9, maxStar: 5, freeInput: false),
    RankInfo(id: 'legend1', name: 'Legend I', tier: 'legend', order: 10, maxStar: 5, freeInput: false),
    RankInfo(id: 'mythic', name: 'Mythic', tier: 'mythic', order: 11, maxStar: 5, freeInput: true),
    RankInfo(id: 'mythic_honor', name: 'Mythic Honor', tier: 'mythic_honor', order: 12, maxStar: 5, freeInput: true),
    RankInfo(id: 'mythical_glory', name: 'Mythical Glory', tier: 'mythical_glory', order: 13, maxStar: 5, freeInput: true),
    RankInfo(id: 'immortal', name: 'Immortal', tier: 'immortal', order: 14, maxStar: 5, freeInput: true),
  ];

  SettingProvider() {
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/settings');
      if (response.statusCode == 200) {
        _settings = SettingModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint('Error fetching settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Settings from Admin Portal
  Future<bool> updateSettings(Map<String, int> newPrices) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/settings', newPrices);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _settings = SettingModel.fromJson(data['settings']);
        return true;
      }
    } catch (e) {
      debugPrint('Error updating settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Helper to map tier names to active price
  int getTierPrice(String tier) {
    if (_settings == null) return 0;
    switch (tier) {
      case 'epic':
        return _settings!.starEpic;
      case 'legend':
        return _settings!.starLegend;
      case 'mythic':
        return _settings!.starMythic;
      case 'mythic_honor':
        return _settings!.starHonor;
      case 'mythical_glory':
        return _settings!.starGlory;
      case 'immortal':
        return _settings!.starImmortal;
      default:
        return 0;
    }
  }

  RankInfo? getRank(String id) {
    return ranks.firstWhere((r) => r.id == id, orElse: () => ranks.first);
  }

  // Price Calculation Engine matching backend/JS logic
  Map<String, dynamic> calculate({
    required String fromRankId,
    required int fromStar,
    required String toRankId,
    required int toStar,
  }) {
    if (_settings == null) {
      return {'totalCost': 0, 'totalStars': 0, 'detail': '', 'errorMsg': 'Loading configurations...'};
    }

    final fromRank = getRank(fromRankId);
    final toRank = getRank(toRankId);

    if (fromRank == null || toRank == null) {
      return {'totalCost': 0, 'totalStars': 0, 'detail': '', 'errorMsg': ''};
    }

    if (toRank.order < fromRank.order) {
      return {
        'totalCost': 0,
        'totalStars': 0,
        'detail': '',
        'errorMsg': 'Rank tujuan harus lebih tinggi atau sama dengan rank saat ini!'
      };
    }
    
    if (toRank.order == fromRank.order && toStar <= fromStar) {
      return {
        'totalCost': 0,
        'totalStars': 0,
        'detail': '',
        'errorMsg': 'Bintang tujuan harus lebih tinggi!'
      };
    }

    int cost = 0;
    int stars = 0;
    List<String> details = [];

    int fromIdx = ranks.indexWhere((r) => r.id == fromRankId);
    int toIdx = ranks.indexWhere((r) => r.id == toRankId);

    if (fromIdx == toIdx) {
      int diff = toStar - fromStar;
      int price = getTierPrice(fromRank.tier);
      if (price > 0 && diff > 0) {
        cost = diff * price;
        stars = diff;
        details.add('${fromRank.name}: $diff⭐ × Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}');
      }
    } else {
      for (int i = fromIdx; i < toIdx; i++) {
        final rank = ranks[i];
        int price = getTierPrice(rank.tier);
        int s = (i == fromIdx) ? (rank.maxStar - fromStar) : rank.maxStar;
        if (s > 0) {
          cost += s * price;
          stars += s;
          details.add('${rank.name}: $s⭐ × Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}');
        }
      }

      if (toStar > 0) {
        final toRankData = ranks[toIdx];
        String prevTier = toIdx > 0 ? ranks[toIdx - 1].tier : toRankData.tier;
        int price = getTierPrice(prevTier);
        if (price == 0) price = getTierPrice(toRankData.tier);
        if (price > 0) {
          cost += toStar * price;
          stars += toStar;
          details.add('${toRankData.name}: $toStar⭐ × Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}');
        }
      }
    }

    return {
      'totalCost': cost,
      'totalStars': stars,
      'detail': details.join(' | '),
      'errorMsg': '',
    };
  }
}
