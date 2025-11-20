import 'package:get/get.dart';

import '../controllers/report_dana_controller.dart';

class ReportDanaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportDanaController>(ReportDanaController.new);
  }
}
