import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';
import 'package:smart_rt/app/data/repository/auth_repository.dart';
import 'package:smart_rt/app/routes/app_pages.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../screen/new_password.dart'; // Import NewPasswordView

/// Controller ini untuk alur 'Lupa/Reset Kata Sandi' (user logout).
/// Controller ini akan dipakai di 3 halaman:
/// 1. VerificationEmailView
/// 2. ResetPasswordView
/// 3. NewPasswordView
class ResetPasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // Text controllers
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final emailController = TextEditingController();

  // Password visibility
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Loading state
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  // Code verification
  final List<TextEditingController> codeControllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(5, (_) => FocusNode());

  // Toggle visibility
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  /// Kirim ulang kode melalui API
  Future<void> resendCode() async {
    if (emailController.text.isEmpty) {
      _showSnack('Error', 'Email tidak ditemukan', app.appErrorMain);
      return;
    }
    isLoading.value = true;
    try {
      final message = await _authRepository.forgotPassword(
        email: emailController.text.trim(),
      );
      _showSnack('Berhasil', message, app.appSuccessMain);
      // Reset code fields
      for (final controller in codeControllers) {
        controller.clear();
      }
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
  }

  /// Otomatis submit saat kode terisi penuh
  void onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }

    // Cek jika semua 5 digit terisi
    if (index == focusNodes.length - 1 && value.isNotEmpty) {
      final fullCode = codeControllers.map((c) => c.text).join('');
      if (fullCode.length == focusNodes.length) {
        submitVerifyCode(fullCode);
      }
    }
  }

  /// [Endpoint: /family/forgot-password]
  /// Dipanggil dari VerificationEmailView
  Future<void> submitEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;
    final email = emailController.text.trim();
    try {
      final message = await _authRepository.forgotPassword(email: email);
      _showSnack('Berhasil', message, app.appSuccessMain);
      Get.toNamed(Routes.RESET_PASSWORD); // Navigasi ke halaman input kode
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
  }

  /// [Endpoint: /family/verify-reset-password]
  /// Dipanggil dari onCodeChanged di ResetPasswordView
  Future<void> submitVerifyCode(String code) async {
    isLoading.value = true;
    final email = emailController.text.trim();

    try {
      final message = await _authRepository.verifyResetPassword(
        email: email,
        code: code,
      );
      _showSnack('Berhasil', message, app.appSuccessMain);
      Get.off(
        () => const NewPasswordView(),
      ); // Navigasi ke halaman password baru
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
      // Reset code fields jika salah
      for (final controller in codeControllers) {
        controller.clear();
      }
      FocusScope.of(Get.context!).requestFocus(focusNodes[0]);
    } finally {
      isLoading.value = false;
    }
  }

  /// [Endpoint: /family/reset-password]
  /// Dipanggil dari NewPasswordView
  Future<void> submitResetPassword() async {
    final email = emailController.text.trim();
    final code = codeControllers.map((c) => c.text).join('');
    final newPass = newPasswordCtrl.text;
    final confirmPass = confirmPasswordCtrl.text;

    // Validasi
    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showSnack('Error', 'Password tidak boleh kosong', app.appErrorMain);
      return;
    }
    if (newPass != confirmPass) {
      _showSnack('Error', 'Password baru tidak cocok', app.appErrorMain);
      return;
    }
    if (email.isEmpty || code.length != 5) {
      _showSnack(
        'Error',
        'Sesi verifikasi tidak valid. Silakan ulangi.',
        app.appErrorMain,
      );
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    isLoading.value = true;
    try {
      final message = await _authRepository.resetPassword(
        email: email,
        code: code,
        password: newPass,
        passwordConfirmation: confirmPass,
      );

      await CustomPopup.show(
        Get.context!,
        title: message,
        subtitle: 'Silakan login dengan password baru Anda.',
        type: PopupType.info,
        lottieAsset: 'assets/lottie/success.json',
        onClose: () {
          Get.offAllNamed(Routes.LOGIN); // Kembali ke Login
        },
      );
      _clearAllFields();
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helper ---
  void _clearAllFields() {
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
    emailController.clear();
    for (final c in codeControllers) {
      c.clear();
    }
  }

  void _showSnack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: app.appTextSecond,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    emailController.dispose();
    for (final c in codeControllers) {
      c.dispose();
    }
    for (final n in focusNodes) {
      n.dispose();
    }
    super.onClose();
  }
}
