import 'package:get/get.dart';
import 'package:smart_rt/app/data/repository/auth_repository.dart';
import 'package:smart_rt/app/data/service/dio_service.dart';

// (Catatan: StorageService tetap di main.dart karena sifatnya async)

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan service yang sinkron (tidak perlu await)
    Get.put(DioService());
    Get.put(AuthRepository());

    // Repository lain bisa ditambahkan di sini
    // Get.put(ProfileRepository());
    // Get.put(IuranRepository());
  }
}
