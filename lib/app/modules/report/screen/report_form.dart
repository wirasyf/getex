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
import '../controllers/report_controller.dart';

class ReportFormView extends StatefulWidget {
  const ReportFormView({super.key});
  @override
  State<ReportFormView> createState() => _ReportFormViewState();
}

class _ReportFormViewState extends State<ReportFormView> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  // Pilih tanggal (date picker)
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      _dateCtrl.text = _formatDate(picked);
      setState(() {});
    }
  }

  // Popup sukses dan kembali
  Future<void> _onSave() async {
    await CustomPopup.show(
      context,
      title: 'Data Pengaduan Telah dikirim!',
      subtitle: 'menunggu balasan',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  // Format date
  String _formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  final year = (d.year % 100).toString().padLeft(2, '0');
  return '$day/$month/$year';
}


  // Image picker
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

  // ignore: unused_element
  Future<void> _submit() async {
    final controller = Get.find<ReportController>();
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final dateText = _dateCtrl.text.isNotEmpty
        ? _dateCtrl.text
        : _formatDate(DateTime.now());
    final imagePath = _selectedImage?.path ?? 'https://i.imgur.com/BoN9kdC.png';

    controller.addReport(
      ReportItem(
        name: 'Joko Handoko',
        title: title.isNotEmpty ? title : 'Tanpa Judul',
        date: dateText,
        description: desc.isNotEmpty ? desc : 'Tidak ada deskripsi',
        imageUrl: imagePath,
        handled: false,
      ),
    );

    await _onSave();
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
              title: 'Form pengaduan',
            ),
          ),

          // Panel konten
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
                      'Judul Pengaduan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Field judul
                    CustomTextField(
                      hint: 'Masukkan judul pengaduan',
                      controller: _titleCtrl,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Foto bukti pengaduan (opsional)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    // Upload foto bukti
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
                                        height: 150,
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
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Field deskripsi
                    Container(
                      decoration: BoxDecoration(
                        color: app.appBackgroundMain,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: app.appNeutralLight),
                      ),
                      child: TextField(
                        controller: _descCtrl,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Masukkan keterangan',
                          hintStyle: const TextStyle(color: app.appTextKet),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: app.appBackgroundMain,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: app.appNeutralLight,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: app.appPrimaryMain,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tanggal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // Field tanggal (tap untuk pilih)
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hint: '00/00/00',
                          controller: _dateCtrl,
                          suffixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            color: app.appTextMain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tombol kirim
                    CustomButton(
                      text: 'Kirim',
                      backgroundColor: app.appInfoDark,
                      onPressed: _onSave,
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
