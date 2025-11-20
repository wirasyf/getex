import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/colors/colors.dart' as app;
import '../../modules/navigation/controllers/navigation_controller.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: app.appBackgroundMain,
          boxShadow: [
            BoxShadow(
              color: app.appTextDark.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Image.asset(
                navController.currentIndex.value == 0
                    ? 'assets/icons/home2.png'
                    : 'assets/icons/home.png',
                width: 26,
                height: 26,
              ),
              label: 'Beranda',
              index: 0,
              isSelected: navController.currentIndex.value == 0,
              onTap: () => navController.changePage(0),
            ),
            _buildNavItem(
              icon: Image.asset(
                navController.currentIndex.value == 1
                    ? 'assets/icons/payment2.png'
                    : 'assets/icons/payment.png',
                width: 26,
                height: 26,
              ),
              label: 'Pembayaran',
              index: 1,
              isSelected: navController.currentIndex.value == 1,
              onTap: () => navController.changePage(1),
            ),
            _buildNavItem(
              icon: Image.asset(
                navController.currentIndex.value == 2
                    ? 'assets/icons/chat2.png'
                    : 'assets/icons/chat.png',
                width: 26,
                height: 26,
              ),
              label: 'Pengaduan',
              index: 2,
              isSelected: navController.currentIndex.value == 2,
              onTap: () => navController.changePage(2),
            ),
            _buildNavItem(
              icon: Image.asset(
                navController.currentIndex.value == 3
                    ? 'assets/icons/profile2.png'
                    : 'assets/icons/profile.png',
                height: 26,
                width: 26,
              ),
              label: 'Profile',
              index: 3,
              isSelected: navController.currentIndex.value == 3,
              onTap: () => navController.changePage(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) => InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: onTap,
    child: SizedBox(
      width: 70,
      height: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Positioned(
                    top: -20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran putih luar
                        Container(
                          height: 66,
                          width: 66,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: app.appBackgroundMain,
                          ),
                        ),
                        // Lingkaran biru utama
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: app.appPrimaryMain,
                            boxShadow: [
                              BoxShadow(
                                color: app.appPrimaryMain.withValues(
                                  alpha: 0.5,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: icon,
                        ),
                      ],
                    ),
                  )
                else
                  icon,
              ],
            ),
          ),
          const SizedBox(height: 6),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                color: app.appPrimaryMain,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    ),
  );
}
