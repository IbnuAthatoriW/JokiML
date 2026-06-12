// lib/screens/order_form_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class OrderFormScreen extends StatefulWidget {
  final String type; // 'paket' or 'custom'
  final double price;
  final String? paketName;
  final String? fromRank;
  final String? toRank;
  final int? fromStar;
  final int? toStar;

  const OrderFormScreen({
    super.key,
    required this.type,
    required this.price,
    this.paketName,
    this.fromRank,
    this.toRank,
    this.fromStar,
    this.toStar,
  });

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _gameIdController = TextEditingController();
  final _moontonAccountController = TextEditingController();
  final _moontonPasswordController = TextEditingController();
  final _heroRequestController = TextEditingController();
  final _whatsappController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _gameIdController.dispose();
    _moontonAccountController.dispose();
    _moontonPasswordController.dispose();
    _heroRequestController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          type: widget.type,
          price: widget.price,
          paketName: widget.paketName,
          fromRank: widget.fromRank,
          toRank: widget.toRank,
          fromStar: widget.fromStar,
          toStar: widget.toStar,
          customerName: _customerNameController.text.trim(),
          gameId: _gameIdController.text.trim(),
          moontonAccount: _moontonAccountController.text.trim(),
          moontonPassword: _moontonPasswordController.text,
          heroRequest: _heroRequestController.text.trim(),
          whatsapp: _whatsappController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Akun Joki',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderCol),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipe Orderan', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary)),
                        const SizedBox(height: 2),
                        Text(
                          widget.type == 'paket' ? 'Paket: ${widget.paketName}' : 'Custom Rank',
                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        if (widget.type == 'custom') ...[
                          const SizedBox(height: 4),
                          Text(
                            '${widget.fromRank} (${widget.fromStar}⭐) → ${widget.toRank} (${widget.toStar}⭐)',
                            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.neonBlue),
                          ),
                        ]
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Biaya', style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary)),
                        const SizedBox(height: 2),
                        Text(
                          'Rp ${widget.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.neonPink),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Inputs Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.neonCardDecoration(shadowColor: AppTheme.primaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Lengkapi Form Akun',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Informasi ini digunakan joki pro kami untuk login dan memproses akun Anda.',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 20),

                    // Customer Name
                    TextFormField(
                      controller: _customerNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap / Nickname',
                        prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Game ID
                    TextFormField(
                      controller: _gameIdController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Game ID (Server ID)',
                        prefixIcon: Icon(Icons.gamepad_outlined, color: AppTheme.textSecondary),
                        hintText: 'contoh: 12345678 (2032)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Game ID wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Moonton Account Email/Username
                    TextFormField(
                      controller: _moontonAccountController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Akun Moonton (Email/HP)',
                        prefixIcon: Icon(Icons.account_circle_outlined, color: AppTheme.textSecondary),
                        hintText: 'Email login akun Moonton',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Akun Moonton wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Moonton Password
                    TextFormField(
                      controller: _moontonPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Kata Sandi Moonton',
                        prefixIcon: Icon(Icons.lock_outline, color: AppTheme.textSecondary),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Moonton wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Hero Request
                    TextFormField(
                      controller: _heroRequestController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Request Hero (Opsional)',
                        prefixIcon: Icon(Icons.shield_outlined, color: AppTheme.textSecondary),
                        hintText: 'contoh: Gusion, Fanny, Chou',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // WhatsApp Number
                    TextFormField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _next(),
                      decoration: const InputDecoration(
                        labelText: 'Nomor WhatsApp Aktif',
                        prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.textSecondary),
                        hintText: 'contoh: 0851xxxxxxxx',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor WhatsApp wajib diisi!';
                        }
                        if (value.length < 9) {
                          return 'Format nomor salah!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Next Button
                    ElevatedButton(
                      onPressed: _next,
                      child: const Text('PROSES KE PEMBAYARAN'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
