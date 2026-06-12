import 'package:flutter/material.dart';
import 'package:jokiml_mobile/services/api_service.dart'; // Import layanan API

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  final TextEditingController _idGameController = TextEditingController();
  final TextEditingController _zoneIdController = TextEditingController();
  final TextEditingController _waController = TextEditingController();

  List<Map<String, dynamic>> _listPaket = [];
  bool _isLoading = true;
  int? _idPaketTerpilih;

  @override
  void initState() {
    super.initState();
    _loadDataPaket(); // Panggil fungsi load data pas aplikasi dibuka
  }

  // Fungsi mengambil data dari SettingApiController web
  Future<void> _loadDataPaket() async {
    try {
      final data = await _apiService.getPaketJoki();
      setState(() {
        _listPaket = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Koneksi backend web terputus: $e')),
      );
    }
  }

  // Fungsi menembak data order ke OrderApiController web
  Future<void> _prosesOrder() async {
    if (_idGameController.text.isEmpty ||
        _zoneIdController.text.isEmpty ||
        _idPaketTerpilih == null ||
        _waController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tolong isi semua formulir pesanan!')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Memproses pesanan...')));

    bool sukses = await _apiService.kirimOrder(
      idGame: _idGameController.text,
      zoneId: _zoneIdController.text,
      paketId: _idPaketTerpilih!,
      nomorWa: _waController.text,
    );

    if (sukses) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF020617),
          title: const Text(
            'Sukses!',
            style: TextStyle(color: Color(0xFF00FFCC)),
          ),
          content: const Text(
            'Pesanan joki masuk ke sistem web. Silakan selesaikan pembayaran!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF00FFCC)),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pesanan ke server.')),
      );
    }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==========================================
              // HERO SECTION
              // ==========================================
              Container(
                margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF020617)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'JOKI MOBILE LEGENDS',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00FFCC),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/images/hero_img.png',
                      width: 250,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.gamepad,
                        size: 80,
                        color: Color(0xFF00FFCC),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // FORM INPUT DATA GAME
              // ==========================================
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Masukkan Data Akun',
                      style: TextStyle(
                        color: Color(0xFF00FFCC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _idGameController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'User ID',
                              filled: true,
                              fillColor: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _zoneIdController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '(Zone)',
                              filled: true,
                              fillColor: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==========================================
              // FORM PILIHAN PAKET JOKI (SINKRON WEB)
              // ==========================================
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Pilih Paket Joki',
                      style: TextStyle(
                        color: Color(0xFF00FFCC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00FFCC),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.8,
                                ),
                            itemCount: _listPaket.length,
                            itemBuilder: (context, index) {
                              final paket = _listPaket[index];
                              // Menyesuaikan kolom nama & harga dari database Jasa/Setting Anda
                              final isSelected =
                                  _idPaketTerpilih == paket['id'];

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _idPaketTerpilih = paket['id'];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF00FFCC)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        paket['title'] ??
                                            paket['nama_jasa'] ??
                                            'Paket Joki',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Rp ${paket['price'] ?? paket['harga'] ?? '0'}',
                                        style: const TextStyle(
                                          color: Color(0xFF00FFCC),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),

              // ==========================================
              // FORM NOMOR WHATSAPP & TOMBOL BELI
              // ==========================================
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3. Kontak & Konfirmasi',
                      style: TextStyle(
                        color: Color(0xFF00FFCC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _waController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Nomor WhatsApp',
                        filled: true,
                        fillColor: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            _prosesOrder, // Jalankan fungsi kirim API saat diklik
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFCC),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Beli Sekarang',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
