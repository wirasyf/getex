import 'package:get/get.dart';

import '../../../data/repository/report_repository.dart';
import '../controllers/report_form_controller.dart';

class ReportFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportRepository());
    Get.lazyPut(() => ReportFormController());
  }
}
