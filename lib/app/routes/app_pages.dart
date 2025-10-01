import 'package:get/get.dart';

<<<<<<< HEAD
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
=======
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
<<<<<<< HEAD
>>>>>>> af48a42fa62ee501e6822bb3255887b42456076a
=======
import '../modules/tes/bindings/tes_binding.dart';
import '../modules/tes/views/tes_view.dart';
>>>>>>> 6c28f41e5ffa63dc8f90be8062cb74213b06a2d1

part 'app_routes.dart';

class AppPages {
  AppPages._();

<<<<<<< HEAD
  static const INITIAL = Routes.PROFILE;

  static final routes = [
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
=======
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
>>>>>>> af48a42fa62ee501e6822bb3255887b42456076a
    ),
    GetPage(
      name: _Paths.TES,
      page: () => const TesView(),
      binding: TesBinding(),
    ),
  ];
}
