import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/report_form_controller.dart';

class ReportFormView extends StatelessWidget {
  const ReportFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportFormController>(
      init: ReportFormController(),
      builder: (controller) {
        return _ReportFormContent(controller: controller);
      },
    );
  }
}

class _ReportFormContent extends StatelessWidget {
  final ReportFormController controller;

  const _ReportFormContent({required this.controller});

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
              title: controller.isEditMode
                  ? 'Edit Pengaduan'
                  : 'Form Pengaduan',
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
                      controller: controller.titleCtrl,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Foto bukti pengaduan (opsional)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    // Upload foto bukti
                    _buildImagePicker(context),
                    const SizedBox(height: 16),

                    const Text(
                      'Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    // Field deskripsi
                    _buildDescriptionField(),
                    const SizedBox(height: 16),

                    const Text(
                      'Tanggal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    // Field tanggal (tap untuk pilih)
                    _buildDateField(),
                    const SizedBox(height: 24),

                    // Tombol kirim/update
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay
          if (controller.isLoading.value)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: app.appBackgroundMain,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: app.appNeutralLight),
        ),
        child: controller.selectedImage.value == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, size: 40, color: app.appTextKet),
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
                        controller.selectedImage.value!.path,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.error, color: app.appErrorMain),
                        ),
                      )
                    : Image.file(
                        File(controller.selectedImage.value!.path),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: app.appNeutralLight),
      ),
      child: TextField(
        controller: controller.descCtrl,
        maxLines: 6,
        decoration: InputDecoration(
          hintText: 'Masukkan keterangan',
          hintStyle: const TextStyle(color: app.appTextKet),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: app.appBackgroundMain),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: app.appNeutralLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: app.appPrimaryMain, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: controller.pickDate,
      child: AbsorbPointer(
        child: CustomTextField(
          hint: '00/00/00',
          controller: controller.periodCtrl,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: app.appTextMain,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return CustomButton(
        text: controller.isEditMode ? 'Update' : 'Kirim',
        backgroundColor: app.appInfoDark,
        onPressed: controller.isLoading.value ? null : controller.submitForm,
      );
    });
  }
}
