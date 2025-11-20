// app/modules/maps/bindings/select_map_binding.dart
import 'package:get/get.dart';
import '../controllers/select_map_controller.dart';

class SelectMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectMapController>(SelectMapController.new);
  }
}
