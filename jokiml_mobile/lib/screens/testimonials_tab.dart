// lib/screens/testimonials_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/testimonial_provider.dart';
import '../models/testimonial_model.dart';
import '../theme/app_theme.dart';

class TestimonialsTab extends StatefulWidget {
  const TestimonialsTab({super.key});

  @override
  State<TestimonialsTab> createState() => _TestimonialsTabState();
}

class _TestimonialsTabState extends State<TestimonialsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestimonialProvider>(context, listen: false).fetchTestimonials();
    });
  }

  void _showAddTestimonialDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTestimonialSheet(),
    );
  }

  void _showReplyDialog(TestimonialModel t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReplyTestimonialSheet(testimonial: t),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testimonialProvider = Provider.of<TestimonialProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isAdmin = authProvider.isAdmin;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => testimonialProvider.fetchTestimonials(),
        child: testimonialProvider.isLoading && testimonialProvider.testimonials.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 4, height: 20, color: AppTheme.neonBlue),
                                const SizedBox(width: 10),
                                Text(
                                  'Testimoni Pelanggan',
                                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Apa kata mereka yang sudah mencoba jasa kami',
                              style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                        if (authProvider.isAuthenticated && !isAdmin)
                          ElevatedButton.icon(
                            onPressed: _showAddTestimonialDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Review'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.neonBlue,
                              shadowColor: AppTheme.neonBlue.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: testimonialProvider.testimonials.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada testimoni.',
                              style: GoogleFonts.inter(color: AppTheme.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: testimonialProvider.testimonials.length,
                            itemBuilder: (context, index) {
                              final t = testimonialProvider.testimonials[index];
                              final bool isOwner = authProvider.isAuthenticated && t.userId == authProvider.user!.id;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: AppTheme.neonCardDecoration(shadowColor: AppTheme.primaryColor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppTheme.primaryColor,
                                          child: Text(
                                            (t.user?.name ?? 'U').substring(0, 1).toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                t.user?.name ?? 'Pelanggan',
                                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: List.generate(
                                                  5,
                                                  (i) => Icon(
                                                    Icons.star_rate_rounded,
                                                    size: 14,
                                                    color: i < t.rating ? Colors.amber : Colors.white24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isOwner || isAdmin)
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: AppTheme.neonPink, size: 18),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('Hapus Testimoni'),
                                                  content: const Text('Apakah Anda yakin ingin menghapus review ini?'),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(ctx).pop(true),
                                                      child: const Text('Hapus', style: TextStyle(color: AppTheme.neonPink)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                await testimonialProvider.deleteTestimonial(t.id);
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '"${t.content}"',
                                      style: GoogleFonts.inter(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.white70, height: 1.4),
                                    ),
                                    
                                    // Admin Reply
                                    if (t.reply != null && t.reply!.isNotEmpty) ...[
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.backgroundColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Balasan Admin:',
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.neonBlue),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              t.reply!,
                                              style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else if (isAdmin) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          onPressed: () => _showReplyDialog(t),
                                          icon: const Icon(Icons.reply, size: 14, color: AppTheme.neonBlue),
                                          label: const Text('Balas', style: TextStyle(fontSize: 12, color: AppTheme.neonBlue)),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ];
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

// 1. Sheet to Add a Testimonial
class AddTestimonialSheet extends StatefulWidget {
  const AddTestimonialSheet({super.key});

  @override
  State<AddTestimonialSheet> createState() => _AddTestimonialSheetState();
}

class _AddTestimonialSheetState extends State<AddTestimonialSheet> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  int _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final provider = Provider.of<TestimonialProvider>(context, listen: false);
    
    final success = await provider.addTestimonial(
      _contentController.text.trim(),
      _rating,
    );

    if (mounted) {
      setState(() => _submitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil dikirim!'), backgroundColor: AppTheme.neonGreen),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim review!'), backgroundColor: AppTheme.neonPink),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tulis Testimoni',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Interactive Stars
              const Text('Penilaian Bintang:', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: starIndex <= _rating ? Colors.amber : Colors.white24,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = starIndex;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Content Form
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Isi Review',
                  hintText: 'Tulis ulasan Anda tentang pelayanan kami di sini...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ulasan tidak boleh kosong!';
                  }
                  if (value.length > 500) {
                    return 'Panjang maksimal ulasan adalah 500 karakter!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Action buttons
              _submitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('KIRIM REVIEW'),
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Sheet to Reply to a Testimonial (Admin only)
class ReplyTestimonialSheet extends StatefulWidget {
  final TestimonialModel testimonial;
  const ReplyTestimonialSheet({super.key, required this.testimonial});

  @override
  State<ReplyTestimonialSheet> createState() => _ReplyTestimonialSheetState();
}

class _ReplyTestimonialSheetState extends State<ReplyTestimonialSheet> {
  final _formKey = GlobalKey<FormState>();
  final _replyController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final provider = Provider.of<TestimonialProvider>(context, listen: false);
    
    final success = await provider.replyTestimonial(
      widget.testimonial.id,
      _replyController.text.trim(),
    );

    if (mounted) {
      setState(() => _submitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Balasan dikirim!'), backgroundColor: AppTheme.neonGreen),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim balasan!'), backgroundColor: AppTheme.neonPink),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Balas Review: ${widget.testimonial.user?.name ?? 'User'}',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                '"${widget.testimonial.content}"',
                style: const TextStyle(color: Colors.white60, fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _replyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Isi Balasan',
                  hintText: 'Tulis balasan admin...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Balasan tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _submitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonBlue),
                      child: const Text('BALAS REVIEW'),
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
