import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/reset_password_controller.dart';

class NewPasswordView extends GetView<ResetPasswordController> {
  const NewPasswordView({super.key});

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
              title: 'Ubah Kata Sandi',
              // Jangan tampilkan back button di sini
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
              // Hapus GetBuilder
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Verifikasi berhasil!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: app.appTextDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Masukkan kata sandi baru dan konfirmasi sandi.',
                            style: TextStyle(
                              fontSize: 14,
                              color: app.appTextDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Obx sudah benar
                          Obx(
                            () => CustomTextField(
                              controller: controller.newPasswordCtrl,
                              hint: 'Masukkan kata sandi baru',
                              obscureText:
                                  !controller.isNewPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isNewPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: app.appTextKet,
                                ),
                                onPressed:
                                    controller.toggleNewPasswordVisibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Obx sudah benar
                          Obx(
                            () => CustomTextField(
                              controller: controller.confirmPasswordCtrl,
                              hint: 'Konfirmasi kata sandi baru',
                              obscureText:
                                  !controller.isConfirmPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isConfirmPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: app.appTextKet,
                                ),
                                onPressed:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Obx untuk loading button sudah benar
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  app.appInfoDark,
                                ),
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              // Arahkan ke submitResetPassword
                              onPressed: controller.submitResetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: app.appInfoDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Simpan kata sandi',
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
