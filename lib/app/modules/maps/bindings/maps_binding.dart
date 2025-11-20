import 'package:get/get.dart';

import '../controllers/maps_controller.dart';

class InputMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsController>(MapsController.new);
  }
}
