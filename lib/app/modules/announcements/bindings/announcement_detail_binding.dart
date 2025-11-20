import 'package:get/get.dart';
import '../../../data/repository/announcement_repository.dart';
import '../controllers/announcement_detail_controller.dart';

class AnnouncementsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get..lazyPut(AnnouncementRepository.new)
    ..lazyPut(AnnouncementDetailController.new);
  }
}
