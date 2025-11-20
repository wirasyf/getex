import 'package:get/get.dart';
import '../../../data/repository/event_repository.dart';
import '../controllers/event_detail_controller.dart';

class EventDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventsRepository());

    // Controller
    Get.lazyPut(() => EventDetailController());
  }
}
