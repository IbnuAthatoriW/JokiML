// lib/models/setting_model.dart
class SettingModel {
  final int priceGmEpic;
  final int priceEpicLegend;
  final int priceLegendMythic;
  final int starGrandmaster;
  final int starEpic;
  final int starLegend;
  final int starMythic;
  final int starHonor;
  final int starGlory;
  final int starImmortal;

  SettingModel({
    required this.priceGmEpic,
    required this.priceEpicLegend,
    required this.priceLegendMythic,
    required this.starGrandmaster,
    required this.starEpic,
    required this.starLegend,
    required this.starMythic,
    required this.starHonor,
    required this.starGlory,
    required this.starImmortal,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      priceGmEpic: json['price_gm_epic'] ?? 60000,
      priceEpicLegend: json['price_epic_legend'] ?? 100000,
      priceLegendMythic: json['price_legend_mythic'] ?? 150000,
      starGrandmaster: json['star_grandmaster'] ?? 3000,
      starEpic: json['star_epic'] ?? 4000,
      starLegend: json['star_legend'] ?? 6000,
      starMythic: json['star_mythic'] ?? 9000,
      starHonor: json['star_honor'] ?? 13000,
      starGlory: json['star_glory'] ?? 30000,
      starImmortal: json['star_immortal'] ?? 100000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_gm_epic': priceGmEpic,
      'price_epic_legend': priceEpicLegend,
      'price_legend_mythic': priceLegendMythic,
      'star_grandmaster': starGrandmaster,
      'star_epic': starEpic,
      'star_legend': starLegend,
      'star_mythic': starMythic,
      'star_honor': starHonor,
      'star_glory': starGlory,
      'star_immortal': starImmortal,
    };
  }
}
