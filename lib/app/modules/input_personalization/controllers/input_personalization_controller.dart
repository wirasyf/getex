import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;

class InputPersonalizationController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final rtCodeController = TextEditingController();
  final selectedStatus = Rx<String?>(null);
  final selectedGender = Rx<String?>(null);
  final selectedDate = Rx<DateTime?>(null);
  final agreeToTerms = false.obs;

  final statusOptions = ['Menikah', 'Belum Menikah', 'Cerai'];
  final genderOptions = ['Laki-laki', 'Perempuan'];

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: app.appPrimaryMain,
            onPrimary: app.appTextSecond,
            onSurface: app.appTextDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Submit personalisasi
  void submit() {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Perhatian',
        'Anda harus menyetujui Syarat dan Ketentuan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: app.appPendingMain,
        colorText: app.appTextSecond,
      );
      return;
    }

    Get.snackbar(
      'Profil Lengkap',
      'Data berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: app.appSuccessMain,
      colorText: app.appTextSecond,
    );
  }

  void openTerms() {
    Get.snackbar(
      'Syarat dan Ketentuan',
      'Membuka Syarat dan Ketentuan',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openPrivacyPolicy() {
    Get.snackbar(
      'Kebijakan Privasi',
      'Membuka Kebijakan Privasi',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openContentPolicy() {
    Get.snackbar(
      'Kebijakan Konten',
      'Membuka Kebijakan Konten',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    rtCodeController.dispose();
    super.onClose();
  }
}
