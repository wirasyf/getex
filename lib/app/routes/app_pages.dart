import 'package:get/get.dart';

<<<<<<< HEAD
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
=======
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
>>>>>>> af48a42fa62ee501e6822bb3255887b42456076a

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
  ];
}
