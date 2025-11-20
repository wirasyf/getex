import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputPersonalizationController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final rtCodeController = TextEditingController();
  final selectedStatus = Rx<String?>(null);
  final selectedGender = Rx<String?>(null);
  final selectedDate = Rx<DateTime?>(null);
  final agreeToTerms = false.obs;

  final genderMap = {'Laki-laki': 'laki-laki', 'Perempuan': 'perempuan'};
  final genderOptions = ['Laki-laki', 'Perempuan'];
  final statusMap = {
    'Kepala Keluarga': 'head_of_family',
    'Ibu': 'mother',
    'Anak': 'child',
  };
  final statusOptions = ['Kepala Keluarga', 'Ibu', 'Anak'];

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Format tanggal ke yyyy-MM-dd
  String formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // === Info Popup ===
  void openTerms() => Get.snackbar(
    'Syarat dan Ketentuan',
    'Membuka Syarat dan Ketentuan',
    snackPosition: SnackPosition.BOTTOM,
  );

  void openPrivacyPolicy() => Get.snackbar(
    'Kebijakan Privasi',
    'Membuka Kebijakan Privasi',
    snackPosition: SnackPosition.BOTTOM,
  );

  void openContentPolicy() => Get.snackbar(
    'Kebijakan Konten',
    'Membuka Kebijakan Konten',
    snackPosition: SnackPosition.BOTTOM,
  );

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    rtCodeController.dispose();
    super.onClose();
  }
}
