import 'package:get/get.dart';
import '../../../data/repository/event_repository.dart';
import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<EventsRepository>(EventsRepository.new)
      ..lazyPut<EventsController>(EventsController.new);
  }
}
