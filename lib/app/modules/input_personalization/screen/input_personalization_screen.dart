import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../routes/app_pages.dart';
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/input_personalization_controller.dart';

class InputPersonalizationView extends GetView<InputPersonalizationController> {
  const InputPersonalizationView({super.key});

  @override
  // Header
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      children: [
        Positioned.fill(child: Container(color: app.appInfoHover)),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            'assets/shapes/wave.png',
            width: MediaQuery.of(context).size.width * 0.8,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;
              final logoH = h * 0.4;
              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: logoH,
                      child: const Image(
                        image: AssetImage('assets/image/logo_smart.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Form panel
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: app.appBackgroundMain,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Silahkan lengkapi data diri',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: app.appTextDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Lengkapi untuk lanjut',
                    style: TextStyle(fontSize: 14, color: app.appTextKet),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    hint: 'Nama lengkap',
                    controller: controller.fullNameController,
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CustomDropdown(
                      hint: 'Status',
                      value: controller.selectedStatus.value,
                      items: controller.statusOptions,
                      onChanged: (value) =>
                          controller.selectedStatus.value = value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CustomDropdown(
                      hint: 'Jenis kelamin',
                      value: controller.selectedGender.value,
                      items: controller.genderOptions,
                      onChanged: (value) =>
                          controller.selectedGender.value = value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => CustomTextField(
                      hint: 'Tanggal lahir',
                      controller: TextEditingController(
                        text: controller.selectedDate.value != null
                            ? controller.formatDate(
                                controller.selectedDate.value!,
                              )
                            : '',
                      ),
                      readOnly: true,
                      onTap: () => controller.selectDate(context),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: app.appTextKet,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    hint: 'No handphone',
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    hint: 'Kode RT',
                    controller: controller.rtCodeController,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Checkbox(
                          value: controller.agreeToTerms.value,
                          onChanged: (value) =>
                              controller.agreeToTerms.value = value ?? false,
                          activeColor: app.appPrimaryMain,
                          side: const BorderSide(
                            color: app.appPrimaryHover,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: RichText(
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            text: TextSpan(
                              style: const TextStyle(
                                color: app.appTextDark,
                                fontSize: 13,
                              ),
                              children: [
                                const TextSpan(text: 'Saya setuju akan '),
                                TextSpan(
                                  text: 'Syarat dan Ketentuan',
                                  style: const TextStyle(
                                    color: app.appInfoHover,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.openTerms,
                                ),
                                const TextSpan(text: ', '),
                                TextSpan(
                                  text: 'Kebijakan Privasi',
                                  style: const TextStyle(
                                    color: app.appInfoHover,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.openPrivacyPolicy,
                                ),
                                const TextSpan(text: ' dan '),
                                TextSpan(
                                  text: 'Kebijakan Konten',
                                  style: const TextStyle(
                                    color: app.appInfoHover,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.openContentPolicy,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Kirim',
                    onPressed: () => Get.toNamed(Routes.VERIFICATION),
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
