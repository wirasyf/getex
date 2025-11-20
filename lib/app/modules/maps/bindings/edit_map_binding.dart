// app/modules/maps/bindings/edit_map_binding.dart
import 'package:get/get.dart';
import '../controllers/edit_map_controller.dart';

class EditMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditMapController>(EditMapController.new);
  }
}
