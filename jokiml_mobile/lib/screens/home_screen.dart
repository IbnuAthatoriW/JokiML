import 'package:flutter/material.dart';
import 'package:jokiml_mobile/services/api_service.dart';
import 'package:jokiml_mobile/screens/order_screen.dart';
import 'package:jokiml_mobile/screens/riwayat_screen.dart';
import 'package:jokiml_mobile/screens/auth_screen.dart';

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
            colors: [Color(0xFF0F0F1A), Color(0xFF050508)],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF00FFCC)),
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
                  color: Color(0xFF00FFCC),
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
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF020617)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'JOKI MOBILE LEGENDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FFCC),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rank boost profesional & terpercaya',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/hero_img.png',
            width: 200,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.gamepad, size: 80, color: Color(0xFF00FFCC)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaketSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paket Rank Boost',
            style: TextStyle(
              color: Color(0xFF00FFCC),
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
    return GestureDetector(
      onTap: () => _pilihPaket(paket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00FFCC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.trending_up,
                color: Color(0xFF00FFCC),
                size: 20,
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
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatHarga(harga),
                    style: const TextStyle(
                      color: Color(0xFF00FFCC),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00FFCC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Pesan',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
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
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Harga per Bintang (Custom)',
            style: TextStyle(
              color: Color(0xFF00FFCC),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Untuk order custom rank, harga dihitung per bintang',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
            },
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Rank',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Per Bintang',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              ...starData.map(
                (item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        item['rank']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _formatHarga(_settings[item['key']]),
                        style: const TextStyle(
                          color: Color(0xFF00FFCC),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                side: const BorderSide(color: Color(0xFF00FFCC)),
                foregroundColor: const Color(0xFF00FFCC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Order Custom Rank'),
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
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00FFCC), size: 28),
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
