import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class VerificationController extends GetxController {
  RxBool isVerified = false.obs;

  void verify() {
    isVerified.value = true;
  }

  // Auto navigate ke pending setelah 5 detik
  void onEnterVerification() {
    Future.delayed(const Duration(seconds: 5), () {
      if (Get.currentRoute != Routes.PENDING) {
        Get.offAllNamed(Routes.PENDING);
      }
    });
  }

  // Auto navigate ke done setelah 5 detik
  void onEnterPending() {
    Future.delayed(const Duration(seconds: 5), () {
      if (Get.currentRoute != Routes.VERIFICATIONDONE) {
        Get.offAllNamed(Routes.VERIFICATIONDONE);
      }
    });
  }

  void onEnterDone() {
    // Navigate to home screen after verification complete
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.currentRoute != Routes.HOME) {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }
}
