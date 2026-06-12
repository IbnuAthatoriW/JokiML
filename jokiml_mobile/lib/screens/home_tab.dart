// lib/screens/home_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/setting_provider.dart';
import '../theme/app_theme.dart';
import 'order_form_screen.dart';
import 'login_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final settings = settingProvider.settings;

    // Default prices if settings not loaded yet
    final int priceP1 = settings?.priceGmEpic ?? 60000;
    final int priceP2 = settings?.priceEpicLegend ?? 100000;
    final int priceP3 = settings?.priceLegendMythic ?? 150000;

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => settingProvider.fetchSettings(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. HERO SECTION
              _buildHeroSection(),

              // 2. CHOOSE PACKAGE SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Paket Joki Rank', 'Pilih paket yang sesuai dengan kebutuhan rank kamu'),
                    const SizedBox(height: 20),
                    settingProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildPackageList(context, authProvider, priceP1, priceP2, priceP3, formatter),
                  ],
                ),
              ),

              // 3. FEATURES SECTION
              _buildFeaturesSection(),

              // 4. FAQ SECTION
              _buildFAQSection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 32),
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.neonBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  '#1 Jasa Joki Terpercaya',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.neonBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.black, height: 1.2),
              children: const [
                TextSpan(text: 'Joki Mobile Legends\n', style: TextStyle(color: Colors.white)),
                TextSpan(text: 'Profesional', style: TextStyle(color: AppTheme.neonPink)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Naik rank lebih cepat, aman, dan terpercaya. Dipercaya oleh ribuan player di seluruh Indonesia.',
            style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildFeatureBadge('✔️ Aman 100%'),
              const SizedBox(width: 8),
              _buildFeatureBadge('⚡ Proses Cepat'),
              const SizedBox(width: 8),
              _buildFeatureBadge('💰 Murah'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderCol, width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 20, color: AppTheme.neonBlue),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPackageList(
    BuildContext context,
    AuthProvider authProvider,
    int priceP1,
    int priceP2,
    int priceP3,
    NumberFormat formatter,
  ) {
    final List<Map<String, dynamic>> pakets = [
      {
        'from': 'Grandmaster',
        'to': 'Epic',
        'price': priceP1,
        'desc': 'Masuk ke ranked Epic dengan bantuan pro player',
        'color': AppTheme.primaryColor,
        'icon': '💎',
        'popular': false,
      },
      {
        'from': 'Epic',
        'to': 'Legend',
        'price': priceP2,
        'desc': 'Tingkatkan skill dan rank ke level Legend',
        'color': AppTheme.neonBlue,
        'icon': '🔥',
        'popular': false,
      },
      {
        'from': 'Legend',
        'to': 'Mythic',
        'price': priceP3,
        'desc': 'Capai rank tertinggi bersama joki profesional',
        'color': AppTheme.neonPink,
        'icon': '👑',
        'popular': true,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pakets.length,
      itemBuilder: (context, index) {
        final p = pakets[index];
        final bool isPopular = p['popular'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppTheme.neonCardDecoration(
            shadowColor: isPopular ? AppTheme.neonPink : AppTheme.primaryColor,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: (p['color'] as Color).withOpacity(0.4), width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              p['icon'],
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${p['from']} → ${p['to']}',
                                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p['desc'],
                                style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppTheme.borderCol.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Harga Paket', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              formatter.format(p['price']),
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.black,
                                color: isPopular ? AppTheme.neonPink : AppTheme.neonBlue,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!authProvider.isAuthenticated) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OrderFormScreen(
                                    type: 'paket',
                                    paketName: '${p['from']} → ${p['to']}',
                                    price: (p['price'] as int).toDouble(),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: p['color'] as Color,
                            shadowColor: (p['color'] as Color).withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          child: const Text('PESAN'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isPopular)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.neonPink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '🔥 POPULER',
                      style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturesSection() {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.shield_outlined, 'title': 'Joki Profesional', 'desc': 'Tim joki berpengalaman dengan winrate tinggi'},
      {'icon': Icons.flash_on_outlined, 'title': 'Proses Cepat', 'desc': 'Estimasi pengerjaan cepat 1-3 hari saja'},
      {'icon': Icons.lock_outline, 'title': 'Aman Tanpa Ban', 'desc': 'Menggunakan VPN, garansi anti-detect 100%'},
      {'icon': Icons.headset_mic_outlined, 'title': 'Support 24 Jam', 'desc': 'Customer service siap membantu via WA'},
    ];

    return Container(
      color: AppTheme.cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('Kenapa Pilih Kami?', 'Kami memberikan pelayanan terbaik untuk setiap customer'),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final f = features[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderCol.withOpacity(0.5), width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(f['icon'] as IconData, color: AppTheme.neonBlue, size: 28),
                    const SizedBox(height: 10),
                    Text(
                      f['title'] as String,
                      style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      f['desc'] as String,
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqs = [
      {
        'q': 'Apakah akun saya aman?',
        'a': 'Ya, 100% aman! Kami menggunakan VPN dan teknik anti-detect sehingga akun Anda tidak akan terkena ban. Kami juga memberikan garansi keamanan akun.'
      },
      {
        'q': 'Berapa lama proses joki?',
        'a': 'Tergantung paket yang dipilih. Rata-rata 1-3 hari kerja. Untuk paket Legend ke Mythic bisa memakan waktu 3-5 hari kerja.'
      },
      {
        'q': 'Apakah bisa request hero tertentu?',
        'a': 'Tentu! Anda bisa request hero favorit yang akan digunakan selama proses joki. Joki kami menguasai semua hero dan role.'
      },
      {
        'q': 'Bagaimana cara pembayaran?',
        'a': 'Kami menerima pembayaran via transfer bank (BCA, BNI, Mandiri), e-wallet (DANA, OVO, GoPay), dan QRIS.'
      },
      {
        'q': 'Apakah ada garansi?',
        'a': 'Ya! Jika rank turun selama proses joki, kami akan menaikkan kembali secara gratis. Kepuasan pelanggan adalah prioritas kami.'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader('Pertanyaan Umum', 'Temukan jawaban untuk pertanyaan yang sering ditanyakan'),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderCol.withOpacity(0.5), width: 1),
                ),
                child: ExpansionTile(
                  title: Text(
                    faq['q']!,
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  iconColor: AppTheme.neonBlue,
                  collapsedIconColor: AppTheme.textSecondary,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq['a']!,
                        style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
