import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class EditProfileController extends GetxController {
  // Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Display data
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxBool isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(() {
      name.value = nameController.text;
    });

    emailController.addListener(() {
      email.value = emailController.text;
    });

    loadUserData();
  }

  void loadUserData() {
    // This should fetch the current user's profile information
    // and populate the respective controllers
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  Future<void> saveChanges() async {
    await CustomPopup.show(
      Get.context!,
      title: 'Perubahan berhasil disimpan!',
      subtitle: 'klik tutup untuk lanjut',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
