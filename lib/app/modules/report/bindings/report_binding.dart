import 'package:get/get.dart';

import '../../../data/repository/report_repository.dart';
import '../controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportRepository());
    Get.lazyPut(() => ReportController());
  }
}
