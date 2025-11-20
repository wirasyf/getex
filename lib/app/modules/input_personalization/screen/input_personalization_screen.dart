import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/widgets/button/custom_button_field.dart';
import 'package:smart_rt/app/widgets/drop_down/costum_drop_down.dart';
import 'package:smart_rt/app/widgets/pop_up/selected_date_field.dart';
import 'package:smart_rt/app/widgets/text_field/custom_text_field.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/controller/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/input_personalization_controller.dart';

class InputPersonalizationView extends GetView<InputPersonalizationController> {
  const InputPersonalizationView({super.key});

  @override
  // Header
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Scaffold(
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
                      () => SelectedDateField(
                        initialDate: controller.selectedDate.value,
                        onDateSelected: (picked) {
                          controller.selectedDate.value = picked;
                        },
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

                    Obx(
                      () => CustomButton(
                        text: profileController.isUpdating.value
                            ? 'Loading...'
                            : 'Masuk',
                        onPressed: profileController.isUpdating.value
                            ? null
                            : () async {
                                if (!controller.agreeToTerms.value) {
                                  Get.snackbar(
                                    'Peringatan',
                                    'Kamu harus setuju dengan syarat dan ketentuan.',
                                  );
                                  return;
                                }

                                final name = controller.fullNameController.text
                                    .trim();
                                final status =
                                    controller.selectedStatus.value ?? '';
                                final gender =
                                    controller.selectedGender.value ?? '';
                                final birthDate =
                                    controller.selectedDate.value != null
                                    ? controller.formatDate(
                                        controller.selectedDate.value!,
                                      )
                                    : '';
                                final phone = controller.phoneController.text
                                    .trim();
                                final rtCode = controller.rtCodeController.text
                                    .trim();

                                if (name.isEmpty ||
                                    status.isEmpty ||
                                    gender.isEmpty ||
                                    birthDate.isEmpty ||
                                    phone.isEmpty ||
                                    rtCode.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Semua data wajib diisi.',
                                  );
                                  return;
                                }
                                final genderApi = controller
                                    .genderMap[controller.selectedGender.value];
                                final statusApi = controller
                                    .statusMap[controller.selectedStatus.value];
                                if (genderApi == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Gender belum dipilih.',
                                  );
                                  return;
                                }
                                if (statusApi == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Status belum dipilih.',
                                  );
                                  return;
                                }

                               final bool isSuccess = await profileController.setIdentity(
                                  name: name,
                                  status: statusApi, // <-- sudah benar
                                  gender: genderApi,
                                  birthDate: birthDate,
                                  phoneNumber: phone,
                                  rtCode: rtCode,
                                );

                                // 2. Cek hasilnya SEBELUM pindah halaman
                                if (isSuccess) {
                                  // HANYA pindah halaman jika sukses
                                  Get.offAllNamed(Routes.VERIFICATION);
                                }
                              },
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
