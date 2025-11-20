import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/navigation/custom_bottom_bar.dart';
import '../../home/bindings/home_binding.dart';
import '../../home/screen/home_screen.dart';
import '../../payment/bindings/payment_binding.dart';
import '../../payment/screen/payment_screen.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../profile/screen/profile_screen.dart';
import '../../report/bindings/report_binding.dart';
import '../../report/screen/report_screen.dart';
import '../controllers/navigation_controller.dart';

class BottomBar extends GetView<NavigationController> {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      Navigator(
        onGenerateRoute: (settings) =>
            GetPageRoute(page: () => const HomeView(), binding: HomeBinding()),
      ),
      Navigator(
        onGenerateRoute: (settings) => GetPageRoute(
          page: () => const PaymentView(),
          binding: PaymentBinding(),
        ),
      ),
      Navigator(
        onGenerateRoute: (settings) => GetPageRoute(
          page: () => const ReportView(),
          binding: ReportBinding(),
        ),
      ),
      Navigator(
        onGenerateRoute: (settings) => GetPageRoute(
          page: () => const ProfileView(),
          binding: ProfileBinding(),
        ),
      ),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }
}
