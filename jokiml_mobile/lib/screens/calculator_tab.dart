// lib/screens/calculator_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/setting_provider.dart';
import '../theme/app_theme.dart';
import 'order_form_screen.dart';
import 'login_screen.dart';

class CalculatorTab extends StatefulWidget {
  const CalculatorTab({super.key});

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  String? _fromRankId;
  int? _fromStar;
  String? _toRankId;
  int? _toStar;

  final TextEditingController _fromStarController = TextEditingController();
  final TextEditingController _toStarController = TextEditingController();

  @override
  void dispose() {
    _fromStarController.dispose();
    _toStarController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    // Triggers recalculation on state update
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Filter target ranks based on selected current rank order
    List<RankInfo> targetRanks = settingProvider.ranks;
    if (_fromRankId != null) {
      final currentRank = settingProvider.getRank(_fromRankId!);
      if (currentRank != null) {
        targetRanks = settingProvider.ranks.where((r) => r.order >= currentRank.order).toList();
      }
    }

    // Do calculation
    Map<String, dynamic> result = {
      'totalCost': 0,
      'totalStars': 0,
      'detail': '',
      'errorMsg': '',
    };

    if (_fromRankId != null && _toRankId != null) {
      final fromRank = settingProvider.getRank(_fromRankId!);
      final toRank = settingProvider.getRank(_toRankId!);

      int? fStar = fromRank?.freeInput == true
          ? int.tryParse(_fromStarController.text)
          : _fromStar;
      int? tStar = toRank?.freeInput == true
          ? int.tryParse(_toStarController.text)
          : _toStar;

      if (fStar != null && tStar != null) {
        result = settingProvider.calculate(
          fromRankId: _fromRankId!,
          fromStar: fStar,
          toRankId: _toRankId!,
          toStar: tStar,
        );
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Container(width: 4, height: 20, color: AppTheme.neonBlue),
                const SizedBox(width: 10),
                Text(
                  'Kalkulator Joki Custom',
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Hitung sendiri biaya joki sesuai rank dan bintang kamu',
              style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // Calculator Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.neonCardDecoration(shadowColor: AppTheme.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current Rank Inputs
                  Text(
                    '📍 Rank Saat Ini',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.neonBlue),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _fromRankId,
                    hint: const Text('-- Pilih Rank --'),
                    dropdownColor: AppTheme.cardColor,
                    items: settingProvider.ranks.map((r) {
                      return DropdownMenuItem<String>(
                        value: r.id,
                        child: Text(r.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _fromRankId = val;
                        _fromStar = null;
                        _fromStarController.clear();
                        // Reset target rank if it's lower than new current rank
                        if (_toRankId != null && _fromRankId != null) {
                          final fromR = settingProvider.getRank(_fromRankId!);
                          final toR = settingProvider.getRank(_toRankId!);
                          if (fromR != null && toR != null && toR.order < fromR.order) {
                            _toRankId = null;
                            _toStar = null;
                            _toStarController.clear();
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  if (_fromRankId != null) ...[
                    Text(
                      '⭐ Bintang Saat Ini',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.neonBlue),
                    ),
                    const SizedBox(height: 8),
                    settingProvider.getRank(_fromRankId!)?.freeInput == true
                        ? TextFormField(
                            controller: _fromStarController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan jumlah bintang (contoh: 20)',
                            ),
                            onChanged: (_) => _calculatePrice(),
                          )
                        : DropdownButtonFormField<int>(
                            value: _fromStar,
                            hint: const Text('-- Pilih Bintang --'),
                            dropdownColor: AppTheme.cardColor,
                            items: List.generate(
                              (settingProvider.getRank(_fromRankId!)?.maxStar ?? 5) + 1,
                              (i) => DropdownMenuItem<int>(value: i, child: Text('$i ⭐')),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _fromStar = val;
                              });
                            },
                          ),
                    const SizedBox(height: 20),
                  ],

                  // Target Rank Inputs
                  Text(
                    '🎯 Rank Tujuan',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.neonPink),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _toRankId,
                    hint: const Text('-- Pilih Rank --'),
                    dropdownColor: AppTheme.cardColor,
                    items: targetRanks.map((r) {
                      return DropdownMenuItem<String>(
                        value: r.id,
                        child: Text(r.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _toRankId = val;
                        _toStar = null;
                        _toStarController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  if (_toRankId != null) ...[
                    Text(
                      '⭐ Bintang Tujuan',
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.neonPink),
                    ),
                    const SizedBox(height: 8),
                    settingProvider.getRank(_toRankId!)?.freeInput == true
                        ? TextFormField(
                            controller: _toStarController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan jumlah bintang (contoh: 50)',
                            ),
                            onChanged: (_) => _calculatePrice(),
                          )
                        : DropdownButtonFormField<int>(
                            value: _toStar,
                            hint: const Text('-- Pilih Bintang --'),
                            dropdownColor: AppTheme.cardColor,
                            items: List.generate(
                              (settingProvider.getRank(_toRankId!)?.maxStar ?? 5) + 1,
                              (i) => DropdownMenuItem<int>(value: i, child: Text('$i ⭐')),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _toStar = val;
                              });
                            },
                          ),
                  ],

                  // ERROR MSG
                  if (result['errorMsg'] != null && (result['errorMsg'] as String).isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.neonPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.neonPink.withOpacity(0.3)),
                      ),
                      child: Text(
                        result['errorMsg'],
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.neonPink, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  // CALCULATION RESULTS
                  if (result['totalCost'] > 0) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.1),
                            AppTheme.neonBlue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderCol, width: 1),
                      ),
                      child: Column(
                        children: [
                          const Text('Total Biaya Joki', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            formatter.format(result['totalCost']),
                            style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.black, color: AppTheme.neonBlue),
                          ),
                          const SizedBox(height: 6),
                          Text('Total ${result['totalStars']} bintang', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                          const SizedBox(height: 12),
                          Text(
                            result['detail'],
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (!authProvider.isAuthenticated) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                              } else {
                                final fromRank = settingProvider.getRank(_fromRankId!);
                                final toRank = settingProvider.getRank(_toRankId!);
                                final int fStar = fromRank?.freeInput == true
                                    ? int.tryParse(_fromStarController.text) ?? 0
                                    : _fromStar ?? 0;
                                final int tStar = toRank?.freeInput == true
                                    ? int.tryParse(_toStarController.text) ?? 0
                                    : _toStar ?? 0;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderFormScreen(
                                      type: 'custom',
                                      fromRank: fromRank?.name,
                                      toRank: toRank?.name,
                                      fromStar: fStar,
                                      toStar: tStar,
                                      price: (result['totalCost'] as int).toDouble(),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.neonBlue,
                              shadowColor: AppTheme.neonBlue.withOpacity(0.3),
                            ),
                            child: const Text('PESAN & BAYAR'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // PRICE LIST TABLE
            _buildPriceTable(settingProvider, formatter),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTable(SettingProvider provider, NumberFormat formatter) {
    final settings = provider.settings;
    final int starEpic = settings?.starEpic ?? 4000;
    final int starLegend = settings?.starLegend ?? 6000;
    final int starMythic = settings?.starMythic ?? 9000;
    final int starHonor = settings?.starHonor ?? 13000;
    final int starGlory = settings?.starGlory ?? 30000;
    final int starImmortal = settings?.starImmortal ?? 100000;

    final List<Map<String, dynamic>> priceList = [
      {'tier': 'Epic → Legend', 'price': starEpic},
      {'tier': 'Legend → Mythic', 'price': starLegend},
      {'tier': 'Mythic → Mythic Honor (0-25)', 'price': starMythic},
      {'tier': 'Mythic Honor → Mythical Glory (25-50)', 'price': starHonor},
      {'tier': 'Mythical Glory → Immortal (50-100)', 'price': starGlory},
      {'tier': 'Immortal → Immortal (100+)', 'price': starImmortal},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderCol.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '📋 Daftar Harga per Bintang:',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: AppTheme.borderCol.withOpacity(0.3), width: 1),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
            },
            children: priceList.map((item) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      item['tier'],
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      formatter.format(item['price']),
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.neonBlue),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
