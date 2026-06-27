import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jokiml_mobile/services/api_service.dart';

class OrderScreen extends StatefulWidget {
  final String type; // 'paket' atau 'custom'
  final double price;
  final String? paketName;
  final String? fromRank;
  final String? toRank;
  final Map<String, dynamic> settings; // harga dari API

  const OrderScreen({
    super.key,
    required this.type,
    required this.price,
    this.paketName,
    this.fromRank,
    this.toRank,
    this.settings = const {},
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ApiService _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _customerNameCtrl = TextEditingController();
  final _gameIdCtrl = TextEditingController();
  final _moontoonAccountCtrl = TextEditingController();
  final _moontoonPasswordCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _heroRequestCtrl = TextEditingController();

  String? _fromRank;
  String? _toRank;
  int _fromStar = 1;
  int _toStar = 5;
  double _customPrice = 0;

  File? _paymentProof;
  bool _passVisible = false;

  final List<String> _rankOptions = [
    'Warrior',
    'Elite',
    'Master',
    'Grandmaster',
    'Epic',
    'Legend',
    'Mythic',
    'Mythic Honor',
    'Mythic Glory',
    'Immortal',
  ];

  // Key mapping dari rank ke key settings API
  final Map<String, String> _rankToSettingsKey = {
    'Grandmaster': 'star_grandmaster',
    'Epic': 'star_epic',
    'Legend': 'star_legend',
    'Mythic': 'star_mythic',
    'Mythic Honor': 'star_honor',
    'Mythic Glory': 'star_glory',
    'Immortal': 'star_immortal',
  };

  @override
  void initState() {
    super.initState();
    _fromRank = widget.fromRank ?? 'Grandmaster';
    _toRank = widget.toRank ?? 'Epic';
    _hitungHargaCustom();
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _gameIdCtrl.dispose();
    _moontoonAccountCtrl.dispose();
    _moontoonPasswordCtrl.dispose();
    _whatsappCtrl.dispose();
    _heroRequestCtrl.dispose();
    super.dispose();
  }

  /// Ambil harga per bintang dari settings API, fallback ke hardcoded
  int _getStarPrice(String? rank) {
    if (rank == null) return 3000;
    final key = _rankToSettingsKey[rank];
    if (key != null && widget.settings.containsKey(key)) {
      return (widget.settings[key] as num).toInt();
    }
    // Fallback jika settings kosong
    const fallback = {
      'Grandmaster': 3000,
      'Epic': 4000,
      'Legend': 6000,
      'Mythic': 9000,
      'Mythic Honor': 13000,
      'Mythic Glory': 30000,
      'Immortal': 100000,
    };
    return fallback[rank] ?? 3000;
  }

  void _hitungHargaCustom() {
    if (widget.type != 'custom') return;
    final hargaPerBintang = _getStarPrice(_fromRank);
    setState(() {
      _customPrice = hargaPerBintang * _fromStar.toDouble();
    });
  }

  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1080,
    );
    if (picked != null) {
      setState(() => _paymentProof = File(picked.path));
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_paymentProof == null) {
      _showSnack('Upload bukti pembayaran terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final finalPrice = widget.type == 'paket' ? widget.price : _customPrice;
      final finalPaketName = widget.type == 'paket'
          ? widget.paketName
          : '$_fromRank ($_fromStar★) → $_toRank ($_toStar★)';

      await _api.createOrder(
        type: widget.type,
        price: finalPrice,
        customerName: _customerNameCtrl.text.trim(),
        gameId: _gameIdCtrl.text.trim(),
        moontoonAccount: _moontoonAccountCtrl.text.trim(),
        moontoonPassword: _moontoonPasswordCtrl.text,
        whatsapp: _whatsappCtrl.text.trim(),
        paymentProof: _paymentProof!,
        paketName: finalPaketName,
        fromRank: widget.type == 'paket' ? widget.fromRank : _fromRank,
        toRank: widget.type == 'paket' ? widget.toRank : _toRank,
        fromStar: widget.type == 'custom' ? _fromStar : null,
        toStar: widget.type == 'custom' ? _toStar : null,
        heroRequest:
            _heroRequestCtrl.text.isEmpty ? null : _heroRequestCtrl.text.trim(),
      );

      if (!mounted) return;
      _showSuksesDialog();
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuksesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF00FFCC)),
            SizedBox(width: 8),
            Text(
              'Order Berhasil!',
              style: TextStyle(color: Color(0xFF00FFCC), fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Pesanan kamu sudah masuk ke sistem. Tim joki akan segera menghubungi kamu via WhatsApp.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // balik ke home
            },
            child: const Text(
              'Kembali ke Beranda',
              style: TextStyle(color: Color(0xFF00FFCC)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red[800] : const Color(0xFF00FFCC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = widget.type == 'custom';
    final hargaTampil = isCustom ? _customPrice : widget.price;

    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F1A),
        title: Text(
          isCustom ? 'Order Custom Rank' : 'Order Paket',
          style: const TextStyle(color: Color(0xFF00FFCC)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00FFCC)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(isCustom, hargaTampil),
              const SizedBox(height: 20),
              if (isCustom) ...[
                _buildCustomRankSection(),
                const SizedBox(height: 20),
              ],
              _buildSection(
                title: 'Data Akun Game',
                children: [
                  _field(
                    ctrl: _gameIdCtrl,
                    label: 'User ID Game (ML)',
                    hint: 'Contoh: 123456789 (1234)',
                    icon: Icons.games_outlined,
                    validator: (v) => v!.isEmpty ? 'User ID wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    ctrl: _moontoonAccountCtrl,
                    label: 'Email / No HP Moonton',
                    hint: 'Untuk login akun kamu',
                    icon: Icons.account_circle_outlined,
                    validator: (v) =>
                        v!.isEmpty ? 'Akun Moonton wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    ctrl: _moontoonPasswordCtrl,
                    label: 'Password Moonton',
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (v) =>
                        v!.isEmpty ? 'Password wajib diisi' : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Data Kontak',
                children: [
                  _field(
                    ctrl: _customerNameCtrl,
                    label: 'Nama Kamu',
                    hint: 'Nama untuk konfirmasi',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    ctrl: _whatsappCtrl,
                    label: 'Nomor WhatsApp',
                    hint: '08xxxxxxxxxx',
                    icon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v!.isEmpty ? 'Nomor WA wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    ctrl: _heroRequestCtrl,
                    label: 'Request Hero (opsional)',
                    hint: 'Kalau ada hero favorit',
                    icon: Icons.star_outline,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildUploadSection(),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FFCC),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Kirim Pesanan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(bool isCustom, double harga) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF020617)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00FFCC).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up, color: Color(0xFF00FFCC), size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCustom
                      ? 'Order Custom'
                      : (widget.paketName ?? 'Paket Joki'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (!isCustom && widget.fromRank != null)
                  Text(
                    '${widget.fromRank} → ${widget.toRank}',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              Text(
                _formatHarga(harga),
                style: const TextStyle(
                  color: Color(0xFF00FFCC),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRankSection() {
    return _buildSection(
      title: 'Pilih Rank Custom',
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rank Sekarang',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  _dropdownRank(
                    value: _fromRank,
                    onChanged: (v) {
                      setState(() => _fromRank = v);
                      _hitungHargaCustom();
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Icon(Icons.arrow_forward, color: Color(0xFF00FFCC)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Rank',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  _dropdownRank(
                    value: _toRank,
                    onChanged: (v) => setState(() => _toRank = v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bintang Sekarang',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  _dropdownBintang(
                    value: _fromStar,
                    onChanged: (v) {
                      setState(() => _fromStar = v!);
                      _hitungHargaCustom();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Bintang',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 6),
                  _dropdownBintang(
                    value: _toStar,
                    onChanged: (v) => setState(() => _toStar = v!),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF00FFCC).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimasi Harga:',
                  style: TextStyle(color: Colors.white54)),
              Text(
                _formatHarga(_customPrice),
                style: const TextStyle(
                  color: Color(0xFF00FFCC),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return _buildSection(
      title: 'Bukti Pembayaran',
      children: [
        const Text(
          'Upload screenshot bukti transfer/pembayaran kamu',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pilihFoto,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _paymentProof != null
                    ? const Color(0xFF00FFCC)
                    : Colors.white24,
              ),
            ),
            child: _paymentProof != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _paymentProof!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          color: Color(0xFF00FFCC), size: 40),
                      SizedBox(height: 8),
                      Text('Tap untuk upload foto',
                          style: TextStyle(color: Colors.white54)),
                      Text('JPG, PNG, WEBP (max 5MB)',
                          style:
                              TextStyle(color: Colors.white24, fontSize: 11)),
                    ],
                  ),
          ),
        ),
        if (_paymentProof != null)
          TextButton(
            onPressed: _pilihFoto,
            child: const Text('Ganti Foto',
                style: TextStyle(color: Color(0xFF00FFCC))),
          ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF020617),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF00FFCC),
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: isPassword && !_passVisible,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        prefixIcon: Icon(icon, color: const Color(0xFF00FFCC), size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white38,
                  size: 18,
                ),
                onPressed: () => setState(() => _passVisible = !_passVisible),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00FFCC), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _dropdownRank({
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF0F172A),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          isExpanded: true,
          items: _rankOptions
              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dropdownBintang({
    required int value,
    required void Function(int?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          dropdownColor: const Color(0xFF0F172A),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          isExpanded: true,
          items: List.generate(5, (i) => i + 1)
              .map((n) => DropdownMenuItem(value: n, child: Text('$n ★')))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _formatHarga(dynamic value) {
    final intVal =
        (value is num) ? value.toInt() : int.tryParse(value.toString()) ?? 0;
    return 'Rp ${intVal.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }
}
