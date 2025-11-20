import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';
import 'package:smart_rt/app/data/repository/auth_repository.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/pop_up/custom_popup_success.dart';

/// Controller ini HANYA untuk alur 'Ubah Kata Sandi' (user sudah login).
class ChangePasswordController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // Text controllers
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  // Password visibility
  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Loading state
  final isLoading = false.obs;

  // Toggle visibility
  void toggleOldPasswordVisibility() => isOldPasswordVisible.toggle();
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  /// [Endpoint: /family/update-password]
  /// Dipanggil dari EditPasswordView
  Future<void> submitUpdatePassword() async {
    final oldPass = oldPasswordCtrl.text;
    final newPass = newPasswordCtrl.text;
    final confirmPass = confirmPasswordCtrl.text;

    // Validasi
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showSnack('Error', 'Semua field wajib diisi', app.appErrorMain);
      return;
    }
    if (newPass != confirmPass) {
      _showSnack('Error', 'Password baru tidak cocok', app.appErrorMain);
      return;
    }

    isLoading.value = true;
    try {
      final message = await _authRepository.updatePassword(
        oldPassword: oldPass,
        newPassword: newPass,
        newPasswordConfirmation: confirmPass,
      );

      // Tampilkan popup sukses
      await CustomPopup.show(
        Get.context!,
        title: message, // Gunakan pesan dari API
        subtitle: 'Klik tutup untuk kembali',
        type: PopupType.info,
        lottieAsset: 'assets/lottie/success.json',
        onClose: Get.back, // Tutup popup dan kembali ke halaman profil
      );
      _clearPasswordFields();
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helper ---
  void _clearPasswordFields() {
    oldPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
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
    oldPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
