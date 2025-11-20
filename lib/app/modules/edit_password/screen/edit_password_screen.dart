import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../routes/app_pages.dart';
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/changes_password_controller.dart';

class EditPasswordView extends GetView<ChangePasswordController> {
  const EditPasswordView({super.key});

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
              title: 'Ubah Kata Sandi',
              showBackButton: true,
              rightWidget: const SizedBox.shrink(),
            ),
          ),

          // Body content
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => CustomTextField(
                              hint: 'Password Lama',
                              controller: controller.oldPasswordCtrl,
                              obscureText:
                                  !controller.isOldPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isOldPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: app.appTextKet,
                                ),
                                onPressed:
                                    controller.toggleOldPasswordVisibility,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => CustomTextField(
                              hint: 'Password Baru',
                              controller: controller.newPasswordCtrl,
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
                          Obx(
                            () => CustomTextField(
                              hint: 'Konfirmasi Password',
                              controller: controller.confirmPasswordCtrl,
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
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              // UPDATE: Navigasi langsung ke halaman verifikasi
                              onPressed: () =>
                                  Get.toNamed(Routes.VERIFICATION_EMAIL),
                              child: const Text(
                                'Lupa password?',
                                style: TextStyle(
                                  color: app.appInfoDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Button tetap di bawah
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: SizedBox(
                                height: 50, // Sesuaikan tinggi
                                width: 50, // Sesuaikan lebar
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    app.appInfoDark,
                                  ),
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : CustomButton(
                              text: 'Ubah kata sandi',
                              onPressed: controller.submitUpdatePassword,
                              backgroundColor: app.appInfoDark,
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
