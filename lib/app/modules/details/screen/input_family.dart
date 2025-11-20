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

class InputFamilyView extends StatefulWidget {
  const InputFamilyView({super.key});

  @override
  State<InputFamilyView> createState() => _InputFamilyViewState();
}

class _InputFamilyViewState extends State<InputFamilyView> {
  final _nameCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _agamaCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();
  final _picker = ImagePicker();
  XFile? _photo;

  final List<String> _genders = const ['Laki-laki', 'Perempuan'];
  String? _selectedGender;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nikCtrl.dispose();
    _birthCtrl.dispose();
    _agamaCtrl.dispose();
    _statusCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (img != null) {
      setState(() => _photo = img);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _birthCtrl.text = _formatDate(picked);
      setState(() {});
    }
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = (d.year % 100).toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  Future<void> _onSave() async {
    await CustomPopup.show(
      context,
      title: 'Perubahan berhasil disimpan!',
      subtitle: 'klik tutup untuk lanjut',
      onClose: Get.back,
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Tambah Anggota Keluarga',
            ),
          ),

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
                      'Foto profil anggota',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.appBackgroundMain,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: app.appNeutralLight),
                        ),
                        child: _photo == null
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
                                        _photo!.path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_photo!.path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Nama lengkap',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hint: 'Masukkan nama lengkap',
                      controller: _nameCtrl,
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'NIK',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hint: 'Masukkan NIK',
                      controller: _nikCtrl,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Agama',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hint: 'Masukkan agama',
                      controller: _agamaCtrl,
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Tanggal lahir',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hint: '00/00/00',
                      controller: _birthCtrl,
                      readOnly: true,
                      onTap: _pickBirthDate,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: app.appTextKet,
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Jenis Kelamin',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomDropdown(
                      hint: 'Pilih jenis kelamin',
                      value: _selectedGender,
                      items: _genders,
                      onChanged: (v) => setState(() => _selectedGender = v),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Status Keluarga',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hint: 'Masukkan status keluarga',
                      controller: _statusCtrl,
                    ),

                    const SizedBox(height: 24),
                    CustomButton(text: 'Simpan', onPressed: _onSave),
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
