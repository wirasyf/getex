import 'package:get/get.dart';
import 'package:smart_rt/app/data/service/dio_service.dart';

import '../../../data/controller/profile_controller.dart';
import '../../../data/datasource/profile_datasource.dart';
import '../../../data/repository/profile_repository.dart';
import '../controllers/input_personalization_controller.dart';

class InputPersonalizationBinding extends Bindings {
  @override
  void dependencies() {
    Get..lazyPut<DioService>(DioService.new)

    ..lazyPut<ProfileDataSource>(
      () => ProfileDataSource(Get.find<DioService>()),
    )

    ..lazyPut<ProfileRepository>(
      () => ProfileRepository(Get.find<ProfileDataSource>()),
    )

    ..lazyPut<ProfileController>(
      () => ProfileController(Get.find<ProfileRepository>()),
    )

    ..lazyPut<InputPersonalizationController>(
      InputPersonalizationController.new,
    );
  }
}
