import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              width: size.width * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.3,
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
                        child: Image.asset(
                          'assets/image/logo_smart.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: app.appTextSecond,
                            size: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.7,
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
                      'Daftar',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: app.appTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'buat akun terlebih dahulu',
                      style: TextStyle(fontSize: 14, color: app.appTextKet),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      hint: 'Username',
                      controller: controller.regUsernameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: 'Email',
                      controller: controller.regEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        hint: 'Password',
                        controller: controller.regPasswordController,
                        obscureText: controller.obscureRegPassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureRegPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: app.appTextKet,
                          ),
                          onPressed: controller.toggleRegPasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        hint: 'Konfirmasi password',
                        controller: controller.regConfirmPasswordController,
                        obscureText: controller.obscureRegConfirmPassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureRegConfirmPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: app.appTextKet,
                          ),
                          onPressed:
                              controller.toggleRegConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.agreeToTerms.value,
                            onChanged: (v) =>
                                controller.agreeToTerms.value = v ?? false,
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
                                      color: app.appPrimaryMain,
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
                                      color: app.appPrimaryMain,
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
                                      color: app.appPrimaryMain,
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
                    Obx(() => CustomButton(
                          text: controller.isLoading.value ? 'Loading...' : 'Daftar',
                          onPressed: controller.isLoading.value ? null : controller.register,
                        )),
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