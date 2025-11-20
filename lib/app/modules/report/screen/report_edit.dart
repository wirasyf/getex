import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_popup_confirm.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/report_controller.dart';

class ReportEditView extends StatefulWidget {
  const ReportEditView({
    required this.index,
    required this.initialTitle,
    required this.initialDate,
    required this.initialDescription,
    super.key,
    this.initialImageUrl,
  });
  final int index;
  final String initialTitle;
  final String initialDate;
  final String initialDescription;
  final String? initialImageUrl;

  @override
  State<ReportEditView> createState() => _ReportEditViewState();
}

class _ReportEditViewState extends State<ReportEditView> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  // Pick tanggal via datepicker
  @override
  void initState() {
    super.initState();
    _titleCtrl.text = widget.initialTitle;
    _descCtrl.text = widget.initialDescription;
    _dateCtrl.text = widget.initialDate;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  // Pick date
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
        setState(() => _selectedImage = image);
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

  // Simpan perubahan ke controller + popup sukses
  Future<void> _save() async {
    final ctrl = Get.find<ReportController>();
    if (widget.index < 0 || widget.index >= ctrl.reports.length) {
      Get.back();
      return;
    }

    final current = ctrl.reports[widget.index];
    final title = _titleCtrl.text.trim().isNotEmpty
        ? _titleCtrl.text.trim()
        : widget.initialTitle;
    final desc = _descCtrl.text.trim().isNotEmpty
        ? _descCtrl.text.trim()
        : widget.initialDescription;
    final dateText = _dateCtrl.text.isNotEmpty
        ? _dateCtrl.text
        : widget.initialDate;
    final imagePath = _selectedImage?.path ?? widget.initialImageUrl;

    ctrl.updateReport(
      widget.index,
      ReportItem(
        name: current.name,
        title: title,
        date: dateText,
        description: desc,
        imageUrl: imagePath,
        handled: current.handled,
      ),
    );

    await CustomPopup.show(
      context,
      title: 'Edit pengaduan berhasil',
      subtitle: 'klik tutup untuk lanjut',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: () {
        if (mounted) {
          Get.back();
        }
      },
    );
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
              title: 'Edit pengaduan',
            ),
          ),
          // Panel konten
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                      'Judul pengaduan',
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
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.appBackgroundMain,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: app.appNeutralLight),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: kIsWeb
                                    ? Image.network(
                                        _selectedImage!.path,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_selectedImage!.path),
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : (widget.initialImageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _initialImageWidget(),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.image_outlined,
                                            size: 40,
                                            color: app.appNeutralMain,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Masukkan foto',
                                            style: TextStyle(
                                              color: app.appTextKet,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
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
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: app.appNeutralLight),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
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

                    CustomButton(
                      text: 'Simpan perubahan',
                      backgroundColor: app.appInfoDark,
                      onPressed: () async {
                        final confirm = await CustomConfirmationPopup.show(
                          context,
                          title: 'Konfirmasi Edit',
                          subtitle:
                              'Apakah Anda yakin ingin menyimpan perubahan?',
                          confirmText: 'Ya, simpan',
                          cancelText: 'Batal',
                          confirmButtonColor: app.appInfoDark,
                        );

                        if (confirm == true) {
                          await _save();
                        }
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

  // Render gambar awal (asset/network/file)
  Widget _initialImageWidget() {
    final path = widget.initialImageUrl;
    if (path == null) {
      return const Center(
        child: Icon(Icons.image_outlined, size: 40, color: app.appNeutralMain),
      );
    }
    if (path.startsWith('http://') ||
        path.startsWith('https://') ||
        path.startsWith('blob:')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    if (path.startsWith('/') || path.contains(r'\')) {
      return kIsWeb
          ? Image.network(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  // Placeholder image
  Widget _fallback() => const Center(
    child: Icon(Icons.broken_image, size: 40, color: app.appNeutralMain),
  );
}
