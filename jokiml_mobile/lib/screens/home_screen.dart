import 'package:flutter/material.dart';
import 'package:jokiml_mobile/services/api_service.dart';
import 'package:jokiml_mobile/screens/badge_chip.dart';
import 'package:jokiml_mobile/screens/order_screen.dart';
import 'package:jokiml_mobile/screens/riwayat_screen.dart';
import 'package:jokiml_mobile/screens/auth_screen.dart';
import 'package:jokiml_mobile/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  Map<String, dynamic> _settings = {};
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  // Daftar paket yang ditampilkan ke user
  // Key harus sama dengan key dari SettingApiController
  final List<Map<String, String>> _paketList = [
    {
      'key': 'price_gm_epic',
      'label': 'Grandmaster → Epic',
      'from': 'Grandmaster',
      'to': 'Epic',
    },
    {
      'key': 'price_epic_legend',
      'label': 'Epic → Legend',
      'from': 'Epic',
      'to': 'Legend',
    },
    {
      'key': 'price_legend_mythic',
      'label': 'Legend → Mythic',
      'from': 'Legend',
      'to': 'Mythic',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([_api.getSettings(), _api.getMe()]);
      setState(() {
        _settings = results[0];
        _user = results[1];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        // Kalau sesi habis / belum login, balik ke AuthScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    }
  }

  Future<void> _logout() async {
    await _api.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  String _formatHarga(dynamic value) {
    if (value == null) return 'Rp 0';
    final number = value is int ? value : int.tryParse(value.toString()) ?? 0;
    // Format angka dengan titik ribuan
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _pilihPaket(Map<String, String> paket) {
    final harga = (_settings[paket['key']] as num?)?.toDouble() ?? 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderScreen(
          type: 'paket',
          paketName: paket['label']!,
          fromRank: paket['from']!,
          toRank: paket['to']!,
          price: harga,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surfaceAlt, AppColors.background],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildHeroSection(),
                      _buildPaketSection(),
                      _buildHargaBintangSection(),
                      _buildMenuSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'JOKI ML',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 3,
                ),
              ),
              if (_user != null)
                Text(
                  'Halo, ${_user!['name']}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white54),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatScreen()),
                ),
                tooltip: 'Riwayat Order',
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white54),
                onPressed: _logout,
                tooltip: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surfaceAlt],
        ),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;
          final heroContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, size: 14, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      '#1 Jasa Joki Terpercaya di Indonesia',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Joki Mobile Legends Profesional',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Naik rank lebih cepat, aman, dan terpercaya. Dipercaya oleh ribuan player di seluruh Indonesia.',
                style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlight,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('🚀 Lihat Paket Joki'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondary),
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: const Text('💬 Kontak WA'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  BadgeChip(label: 'Aman 100%'),
                  BadgeChip(label: 'Proses Cepat'),
                  BadgeChip(label: 'Harga Terjangkau'),
                ],
              ),
            ],
          );

          final heroImage = AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.16),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/hero_img.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.gamepad, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heroContent,
                const SizedBox(height: 24),
                heroImage,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: heroContent),
              const SizedBox(width: 16),
              Expanded(child: heroImage),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaketSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paket Rank Boost',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Harga sudah termasuk semua rank yang dipilih',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ..._paketList.map((paket) {
            final harga = _settings[paket['key']];
            return _paketCard(paket, harga);
          }),
        ],
      ),
    );
  }

  Widget _paketCard(Map<String, String> paket, dynamic harga) {
    final isPopular = paket['label'] == 'Legend → Mythic';
    return GestureDetector(
      onTap: () => _pilihPaket(paket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.surfaceAlt, AppColors.surfaceSoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Stack(
          children: [
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.highlight.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '🔥 Terpopuler',
                    style: TextStyle(
                      color: AppColors.highlight,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paket['label']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatHarga(harga),
                        style: const TextStyle(
                          color: AppColors.highlight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Pesan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHargaBintangSection() {
    // Harga per bintang dari settings
    final starData = [
      {'rank': 'Grandmaster', 'key': 'star_grandmaster'},
      {'rank': 'Epic', 'key': 'star_epic'},
      {'rank': 'Legend', 'key': 'star_legend'},
      {'rank': 'Mythic', 'key': 'star_mythic'},
      {'rank': 'Mythic Honor', 'key': 'star_honor'},
      {'rank': 'Mythic Glory', 'key': 'star_glory'},
      {'rank': 'Immortal', 'key': 'star_immortal'},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surfaceAlt],
        ),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Harga per Bintang (Custom)',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Untuk order custom rank, harga dihitung per bintang',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
            },
            border: TableBorder.symmetric(
              inside: BorderSide(color: AppColors.border.withOpacity(0.3)),
            ),
            children: [
              const TableRow(
                decoration: BoxDecoration(color: AppColors.surfaceSoft),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Tier',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Harga/Bintang',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              ...starData.map(
                (item) => TableRow(
                  decoration: const BoxDecoration(color: AppColors.surface),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        item['rank']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _formatHarga(_settings[item['key']]),
                        style: const TextStyle(
                          color: AppColors.highlight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderScreen(type: 'custom', price: 0),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.secondary),
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              ),
              child: const Text(
                'Order Custom Rank',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _menuCard(
              icon: Icons.receipt_long,
              label: 'Riwayat\nOrder',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RiwayatScreen()),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _menuCard(
              icon: Icons.add_circle_outline,
              label: 'Order\nBaru',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderScreen(type: 'paket', price: 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
