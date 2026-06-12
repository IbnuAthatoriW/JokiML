// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_tab.dart';
import 'calculator_tab.dart';
import 'history_tab.dart';
import 'testimonials_tab.dart';
import 'admin_orders_screen.dart'; // Admin Orders manage
import 'admin_settings_screen.dart'; // Admin Settings price manage
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _LoginRedirect extends StatelessWidget {
  const _LoginRedirect();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_person_outlined, size: 64, color: AppTheme.neonPink),
          const SizedBox(height: 16),
          Text(
            'Silakan masuk terlebih dahulu',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of standard tabs
  final List<Widget> _userTabs = [
    const HomeTab(),
    const CalculatorTab(),
    const TestimonialsTab(),
    const HistoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isAdmin = authProvider.isAdmin;

    // Build tab list dynamically based on admin role
    final List<Widget> tabs = List.from(_userTabs);
    if (isAdmin) {
      // Admin sees setting/orders tabs or redirects
      // Let's place Admin Orders management inside main tabs
      tabs.add(const AdminOrdersScreen());
      tabs.add(const AdminSettingsScreen());
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.primaryColor.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.sports_esports_rounded,
                color: AppTheme.neonBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'JokiML',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.black,
                fontSize: 22,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        actions: [
          if (authProvider.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderCol, width: 1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isAdmin ? AppTheme.neonPink : AppTheme.primaryColor,
                      child: Text(
                        authProvider.user!.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      authProvider.user!.name.split(' ').first,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.neonPink, size: 20),
              tooltip: 'Keluar',
              onPressed: () async {
                final bool confirm = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Keluar Akun'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Keluar', style: TextStyle(color: AppTheme.neonPink))),
                    ],
                  ),
                ) ?? false;

                if (confirm && mounted) {
                  await authProvider.logout();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ] else
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text('Masuk', style: TextStyle(color: AppTheme.neonBlue)),
            ),
        ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (authProvider.isAuthenticated || _selectedIndex < 2)
              ? tabs[_selectedIndex]
              : const _LoginRedirect(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= tabs.length ? 0 : _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.cardColor,
        selectedItemColor: AppTheme.neonBlue,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            activeIcon: Icon(Icons.rate_review),
            label: 'Testimoni',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          if (isAdmin) ...[
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings),
              label: 'Adm Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Adm Prices',
            ),
          ],
        ],
      ),
    );
  }
}
