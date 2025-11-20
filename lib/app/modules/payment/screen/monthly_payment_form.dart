import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/payment_controller.dart';

// --- NAMA CLASS DIUBAH ---
class MonthlyPaymentFormView extends StatefulWidget {
  // item yang akan dibayar (opsional)
  const MonthlyPaymentFormView({super.key, this.targetItem});
  final PaymentItem? targetItem;

  @override
  // --- NAMA STATE DIUBAH ---
  State<MonthlyPaymentFormView> createState() => _MonthlyPaymentFormViewState();
}

// --- NAMA STATE DIUBAH ---
class _MonthlyPaymentFormViewState extends State<MonthlyPaymentFormView> {
  final TextEditingController _amountCtrl = TextEditingController();
  String _selectedMonth = 'Oktober';
  final List<String> _months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  late List<String> _choices;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  // Cleanup controllers
  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  // pick image
  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih foto: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Prefill dari target item jika ada
    final t = widget.targetItem;
    _choices = List<String>.from(_months);
    if (t != null) {
      _selectedMonth = t.title;
      _amountCtrl.text = t.amount; // biarkan format teks seperti data mock
      if (!_choices.contains(t.title)) {
        _choices.insert(0, t.title);
      }
    }
    // Pastikan nilai awal ada di daftar choices
    if (!_choices.contains(_selectedMonth) && _choices.isNotEmpty) {
      _selectedMonth = _choices.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              // --- JUDUL HEADER DIUBAH ---
              title: 'Form Pembayaran Bulanan',
            ),
          ),

          // Content panel
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Foto bukti transfer / pembayaran',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    // Upload bukti foto
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: app.appBackgroundMain,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: app.appNeutralLight),
                        ),
                        child: _selectedImage == null
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: app.appTextKet,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Masukkan foto',
                                      style: TextStyle(
                                        color: app.appTextKet,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.network(
                                        _selectedImage!.path,
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: app.appErrorMain,
                                              ),
                                            ),
                                      )
                                    : Image.file(
                                        File(_selectedImage!.path),
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bulan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Dropdown bulan
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: app.appBackgroundMain,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: app.appNeutralLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedMonth,
                          isExpanded: true,
                          style: const TextStyle(
                            color: app.appTextKet,
                            fontWeight: FontWeight.w600,
                          ),
                          items: _choices
                              .map(
                                (m) => DropdownMenuItem<String>(
                                  value: m,
                                  child: Text(
                                    m,
                                    style: const TextStyle(
                                      color: app.appTextKet,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(
                            () => _selectedMonth = v ?? _selectedMonth,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nominal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Field nominal
                    CustomTextField(
                      hint: 'Rp.',
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    // Tombol kirim
                    CustomButton(
                      text: 'Kirim',
                      backgroundColor: app.appInfoDark,
                      onPressed: () async {
                        // Update status & popup sukses
                        // (LOGIC INI SAMA SEPERTI ASLI)
                        final ctrl = Get.find<PaymentController>();
                        final chosen = _selectedMonth;
                        final newAmount = _amountCtrl.text.trim();

                        var updatedAny = false;
                        final t = widget.targetItem;
                        final copy = <PaymentItem>[...ctrl.payments];

                        if (t != null) {
                          for (var i = 0; i < copy.length; i++) {
                            final p = copy[i];
                            if (p.title == t.title &&
                                p.year == t.year &&
                                p.amount == t.amount) {
                              copy[i] = PaymentItem(
                                title: p.title,
                                description: p.description,
                                amount: newAmount.isNotEmpty
                                    ? newAmount
                                    : p.amount,
                                year: p.year,
                                status: PaymentStatus.proses,
                              );
                              updatedAny = true;
                              break;
                            }
                          }
                        }

                        // Fallback: update pertama yang cocok judulnya
                        if (!updatedAny) {
                          for (var i = 0; i < copy.length; i++) {
                            final p = copy[i];
                            if (p.title == chosen) {
                              copy[i] = PaymentItem(
                                title: p.title,
                                description: p.description,
                                amount: newAmount.isNotEmpty
                                    ? newAmount
                                    : p.amount,
                                year: p.year,
                                status: PaymentStatus.proses,
                              );
                              updatedAny = true;
                              break;
                            }
                          }
                        }

                        if (updatedAny) {
                          ctrl.payments.value = copy;
                        }

                        await CustomPopup.show(
                          context,
                          title: 'Data Pembayaran Telah dikirim!',
                          subtitle: 'menunggu verifikasi',
                          type: PopupType.info,
                          lottieAsset: 'assets/lottie/success.json',
                          onClose: Get.back,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
