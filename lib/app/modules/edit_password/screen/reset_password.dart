import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/code_input.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/edit_password_controller.dart';

class ResetPasswordView extends GetView<EditPasswordController> {
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
                              'Untuk melanjutkan proses pemulihan kata sandi',
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
                                  'Tidak menerima kode verifikasi? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: app.appTextKet,
                                  ),
                                ),
                                GestureDetector(
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
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: app.appNeutralHover,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            controller.getFormattedTime(),
                            style: const TextStyle(
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
          ),
        ],
      ),
    );
  }
}
