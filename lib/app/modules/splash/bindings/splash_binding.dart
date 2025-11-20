import 'package:get/get.dart';
import 'package:smart_rt/app/modules/splash/controllers/splash_controller.dart';


class SplashSmartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashSmartController>(
      () => SplashSmartController(),
    );
  }
}
