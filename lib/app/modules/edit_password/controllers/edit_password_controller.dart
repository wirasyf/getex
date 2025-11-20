import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../screen/new_password.dart';

class EditPasswordController extends GetxController {
  // Text controllers
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final emailController = TextEditingController();

  // Password visibility
  final isOldPasswordVisible = false.obs;
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
  RxInt remainingSeconds = 0.obs;
  Timer? _timer;

  // Toggle visibility
  void toggleOldPasswordVisibility() => isOldPasswordVisible.toggle();
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  // Start countdown (called only in ResetPasswordView)
  void startCountdownToNewPassword() {
    remainingSeconds.value = 5;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        Get.off(() => const NewPasswordView());
      }
    });
  }

  String getFormattedTime() => 'Tunggu ${remainingSeconds.value}s';

  void resendCode() {
    for (final controller in codeControllers) {
      controller.clear();
    }
    startCountdownToNewPassword();
  }

  void onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
    }
  }

  Future<void> submitChangePassword() async {
    await CustomPopup.show(
      Get.context!,
      title: 'Perubahan berhasil disimpan!',
      subtitle: 'Klik tutup untuk lanjut',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  void submitEmail() {
    Get.toNamed('/reset-password');
  }

  void changePassword() {
    Get.toNamed('/verification-email');
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.currentRoute == '/reset-password') {
      startCountdownToNewPassword();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    oldPasswordCtrl.dispose();
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
