import 'package:get/get.dart';
import '../../../data/repository/announcement_repository.dart';
import '../controllers/announcement_controller.dart';

class AnnouncementsBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get..lazyPut<AnnouncementRepository>(AnnouncementRepository.new)

    // Controller
    ..lazyPut<AnnouncementsController>(AnnouncementsController.new);
  }
}
