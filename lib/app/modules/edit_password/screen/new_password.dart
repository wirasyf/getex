import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/edit_password_controller.dart';

class NewPasswordView extends GetView<EditPasswordController> {
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
              child: GetBuilder<EditPasswordController>(
                builder: (controller) => Column(
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
                            CustomTextField(
                              controller: controller.newPasswordCtrl,
                              hint: 'Masukkan kata sandi baru',
                              isPasswordVisible:
                                  controller.isNewPasswordVisible.value,
                              onVisibilityToggle:
                                  controller.toggleNewPasswordVisibility,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.confirmPasswordCtrl,
                              hint: 'Konfirmasi kata sandi baru',
                              isPasswordVisible:
                                  controller.isConfirmPasswordVisible.value,
                              onVisibilityToggle:
                                  controller.toggleConfirmPasswordVisibility,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.submitChangePassword,
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
