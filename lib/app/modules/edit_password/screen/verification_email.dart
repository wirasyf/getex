import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
// GANTI IMPORT: Arahkan ke controller yang baru
import '../controllers/reset_password_controller.dart';

// GANTI CONTROLLER: Gunakan ResetPasswordController
class VerificationEmailView extends GetView<ResetPasswordController> {
  const VerificationEmailView({super.key});

  @override
  // Header
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
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: 'Verifikasi Email',
              showBackButton: true, // Tambahkan back button
            ),
          ),

          // Body content
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
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              // HAPUS GetBuilder (sudah di-handle GetView dan Binding)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Masukkan alamat email anda',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: app.appTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Untuk melanjutkan proses pemulihan kata sandi',
                              style: TextStyle(
                                fontSize: 14,
                                color: app.appTextDark,
                              ),
                              // Hapus textAlign (lebih baik rata kiri)
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: app.appBackgroundMain,
                                hintText: 'Masukkan email anda',
                                hintStyle: const TextStyle(
                                  color: app.appTextKet,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: app.appNeutralLight,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: app.appNeutralLight,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide(
                                    color: app.appInfoDark,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Email tidak valid';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // GANTI: Bungkus tombol dengan Obx untuk loading
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  app.appInfoDark,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: controller.submitEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: app.appInfoDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Kirim',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: app.appTextSecond,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
