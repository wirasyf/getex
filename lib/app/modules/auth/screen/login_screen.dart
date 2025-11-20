import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

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
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: app.appBackgroundMain,
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
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: app.appTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Selamat datang kembali',
                      style: TextStyle(fontSize: 14, color: app.appTextDark),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      hint: 'Username',
                      controller: controller.usernameController,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        hint: 'Password',
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: app.appTextKet,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.rememberMe.value, // <-- Ini perbaikannya
                                onChanged: (value) =>
                                    controller.rememberMe.value = value ?? false, // <-- Ini perbaikannya
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
                            const Text(
                              'Ingat Login Saya',
                              style: TextStyle(
                                color: app.appTextKet,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: controller.forgotPassword,
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: app.appInfoDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Obx(() => CustomButton(
                          text: controller.isLoading.value ? 'Loading...' : 'Masuk',
                          onPressed: controller.isLoading.value ? null : controller.login,
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            color: app.appTextDark,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          child: const Text(
                            'Daftar disini',
                            style: TextStyle(
                              color: app.appInfoDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: app.appNeutralLight)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Atau',
                            style: TextStyle(
                              color: app.appTextKet,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: app.appNeutralLight)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: app.appTextDark, width: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.loginWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: app.appBackgroundMain,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image/icon_google.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.g_mobiledata,
                                  color: app.appErrorMain,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Masuk dengan Google',
                                style: TextStyle(
                                  color: app.appTextKet,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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