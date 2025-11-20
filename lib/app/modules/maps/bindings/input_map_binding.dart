// app/modules/maps/bindings/input_map_binding.dart
import 'package:get/get.dart';
import '../controllers/input_map_controller.dart';

class InputMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputMapController>(InputMapController.new);
  }
}
