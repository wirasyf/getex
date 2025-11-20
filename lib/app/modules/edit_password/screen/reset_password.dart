import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/code_input.dart';
import '../../../widgets/header/header_menu.dart';
// GANTI IMPORT: Arahkan ke controller yang baru
import '../controllers/reset_password_controller.dart';

// GANTI CONTROLLER: Gunakan ResetPasswordController
class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  //Header
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
              title: 'Reset Kata Sandi',
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
              // Hapus GetBuilder
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Masukkan kode verifikasi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: app.appTextDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Kode telah dikirim ke email Anda',
                            style: TextStyle(
                              fontSize: 14,
                              color: app.appTextDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              5,
                              (index) => CodeInputField(
                                controller: controller.codeControllers[index],
                                focusNode: controller.focusNodes[index],
                                onChanged: (value) =>
                                    controller.onCodeChanged(index, value),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tidak menerima kode? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: app.appTextKet,
                                ),
                              ),
                              GestureDetector(
                                // Arahkan ke resendCode
                                onTap: controller.resendCode,
                                child: const Text(
                                  'Kirim ulang',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: app.appInfoDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // UI Loading sudah benar menggunakan Obx
                  Obx(
                    () => SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  app.appInfoDark,
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                'Masukkan 5 digit kode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: app.appTextKet,
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
