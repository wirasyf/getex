import 'package:get/get.dart';

import '../../../data/repository/report_repository.dart';
import '../controllers/report_detail_controller.dart';

class ReportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportRepository());
    Get.lazyPut(() => ReportDetailController());
  }
}
