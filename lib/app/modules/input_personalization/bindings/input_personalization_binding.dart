import 'package:get/get.dart';

import '../controllers/input_personalization_controller.dart';

class InputPersonalizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputPersonalizationController>(
      InputPersonalizationController.new,
    );
  }
}
