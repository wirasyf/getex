import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/pop_up/custom_popup_confirm.dart';

class ProfileController extends GetxController {
  RxString username = 'Username'.obs;
  RxString email = 'gmail@gmail.com'.obs;

  // ignore: use_setters_to_change_properties
  void updateUsername(String newName) {
    username.value = newName;
  }

  Future<void> logout() async {
    final result = await CustomConfirmationPopup.show(
      Get.context!,
      title: 'Konfirmasi Keluar',
      subtitle: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      imageAsset: 'assets/ilustration/question.png',
    );

    if (result == true) {
      await Get.offAllNamed(Routes.LOGIN);
    }
  }

  void goToPaymentHistory() => Get.toNamed('/payment-history');
  void goToEditProfile() => Get.toNamed('/edit-profile');
  void goToTerms() => Get.toNamed('/terms');
  void goToFaq() => Get.toNamed(Routes.FAQ);
  void goToLocation() => Get.toNamed(Routes.EDIT_MAP);
  void goToEditPassword() => Get.toNamed(Routes.EDIT_PASSWORD);
}
