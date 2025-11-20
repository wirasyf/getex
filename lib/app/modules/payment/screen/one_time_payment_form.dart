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

class OneTimePaymentFormView extends StatefulWidget {
  // item yang akan dibayar (opsional)
  const OneTimePaymentFormView({super.key, this.targetItem});
  final PaymentItem? targetItem;

  @override
  State<OneTimePaymentFormView> createState() => _OneTimePaymentFormViewState();
}

class _OneTimePaymentFormViewState extends State<OneTimePaymentFormView> {
  final TextEditingController _amountCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  // --- VARIABEL BARU UNTUK DROPDOWN ---
  String? _selectedPaymentOption; // Menyimpan opsi yang dipilih
  List<String> _paymentOptions = []; // List opsi dari controller
  // Map untuk menyimpan judul -> nominal
  final Map<String, String> _paymentAmounts = {};
  // --- AKHIR PERUBAHAN ---

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
    final ctrl = Get.find<PaymentController>();
    final t = widget.targetItem;

    // --- LOGIC INITSTATE DIUBAH ---
    // Ambil data dari controller (yang list-nya sudah ter-filter 'Sekali Bayar')
    // Kita pakai Map dulu untuk mengambil judul unik dan nominalnya
    for (final item in ctrl.payments) {
      if (!_paymentAmounts.containsKey(item.title)) {
        _paymentAmounts[item.title] = item.amount;
      }
    }
    // Ubah keys dari Map menjadi List untuk dropdown
    _paymentOptions = _paymentAmounts.keys.toList();

    if (t != null) {
      // Prefill dari item spesifik yang diklik user
      _amountCtrl.text = t.amount;
      // Set dropdown agar sesuai dengan item yang diklik
      if (_paymentOptions.contains(t.title)) {
        _selectedPaymentOption = t.title;
      }
    }

    // Fallback jika tidak ada item yang diklik ATAU itemnya tidak ada di list
    if (_selectedPaymentOption == null && _paymentOptions.isNotEmpty) {
      _selectedPaymentOption = _paymentOptions.first;
      // Set nominal awal berdasarkan pilihan dropdown pertama
      _amountCtrl.text = _paymentAmounts[_selectedPaymentOption] ?? '';
    }
    // --- AKHIR PERUBAHAN ---
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
              title: 'Form Sekali Bayar',
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
                    // Upload bukti foto (Sama)
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

                    // --- TEXTFIELD DIGANTI MENJADI DROPDOWN ---
                    const Text(
                      'Opsi Pembayaran', // Label diubah
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: app.appBackgroundMain,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: app.appNeutralLight),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPaymentOption,
                          isExpanded: true,
                          style: const TextStyle(
                            color: app.appTextKet,
                            fontWeight: FontWeight.w600,
                          ),
                          hint: const Text(
                            'Pilih Pembayaran',
                            style: TextStyle(
                              color: app.appTextKet,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          items: _paymentOptions
                              .map(
                                (optionTitle) => DropdownMenuItem<String>(
                                  value: optionTitle,
                                  child: Text(
                                    optionTitle,
                                    style: const TextStyle(
                                      color: app.appTextKet,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                _selectedPaymentOption = v;
                                // Update nominal field saat dropdown diganti
                                _amountCtrl.text = _paymentAmounts[v] ?? '';
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    // --- AKHIR PERUBAHAN ---
                    const SizedBox(height: 16),
                    const Text(
                      'Nominal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Field nominal (tetap bisa diedit, tapi terisi otomatis)
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
                        // --- LOGIC SUBMIT DISESUAIKAN ---
                        final ctrl = Get.find<PaymentController>();

                        // Ambil data dari state dropdown, bukan widget.targetItem
                        final String? chosenPaymentTitle =
                            _selectedPaymentOption;
                        final newAmount = _amountCtrl.text.trim();

                        // Validasi jika belum memilih
                        if (chosenPaymentTitle == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan pilih opsi pembayaran.'),
                            ),
                          );
                          return;
                        }

                        var updatedAny = false;
                        final t = widget.targetItem;
                        final copy = <PaymentItem>[...ctrl.payments];

                        // Prioritas 1: Update item yg diklik (targetItem),
                        // JIKA user tidak mengubah dropdown.
                        if (t != null && t.title == chosenPaymentTitle) {
                          for (var i = 0; i < copy.length; i++) {
                            final p = copy[i];
                            // Cari item yg sama persis dgn yg diklik
                            if (p.title == t.title &&
                                p.year == t.year &&
                                p.amount == t.amount &&
                                p.status == t.status) {
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

                        // Prioritas 2 (Fallback): Jika tidak ada targetItem,
                        // atau user MENGGANTI dropdown,
                        // update item PERTAMA yg 'Belum Lunas' & cocok dgn judul.
                        if (!updatedAny) {
                          for (var i = 0; i < copy.length; i++) {
                            final p = copy[i];
                            if (p.title == chosenPaymentTitle &&
                                p.status == PaymentStatus.belumLunas) {
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

                        // Prioritas 3 (Fallback 2): Jika tidak ada yg 'Belum Lunas',
                        // update item PERTAMA yg cocok dgn judul (apapun statusnya).
                        if (!updatedAny) {
                          for (var i = 0; i < copy.length; i++) {
                            final p = copy[i];
                            if (p.title == chosenPaymentTitle) {
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
