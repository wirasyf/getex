import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/colors/colors.dart' as app;
import '../../modules/home/controllers/home_controller.dart';
import '../../routes/app_pages.dart';

class SideBar extends GetView<HomeController> {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    backgroundColor: app.appBackgroundMain,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(color: app.appInfoHover),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/shapes/wave8.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 16,
              top: 50,
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // tutup drawer
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.menu, color: app.appTextSecond, size: 30),
                      SizedBox(width: 12),
                      Text(
                        'Menu',
                        style: TextStyle(
                          color: app.appTextSecond,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Menu list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _buildMenuItem(
                icon: Image.asset(
                  'assets/icons/history.png',
                  width: 24,
                  height: 24,
                ),
                backgroundColor: app.appSuccessLight,
                title: 'Riwayat transaksi',
                onTap: () => Get.toNamed(Routes.PAYMENT_HISTORY),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                icon: Image.asset(
                  'assets/icons/dana.png',
                  width: 24,
                  height: 24,
                ),
                backgroundColor: app.appPendingLight,
                title: 'Laporan dana',
                onTap: () => Get.toNamed(Routes.REPORT_DANA),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                icon: Image.asset(
                  'assets/icons/speaker.png',
                  width: 24,
                  height: 24,
                ),
                backgroundColor: app.appInfoLight,
                title: 'Pengumuman',
                onTap: () => Get.toNamed(Routes.ANNOUNCEMENT),
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                icon: Image.asset(
                  'assets/icons/doc.png',
                  width: 24,
                  height: 24,
                ),
                backgroundColor: app.appPrimaryLight,
                title: 'Event',
                onTap: () => Get.toNamed(Routes.EVENT),
              ),
            ],
          ),
        ),

        // Footer
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Copyright by SMART RT',
              style: TextStyle(fontSize: 12, color: app.appTextKet),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) => Builder(
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: app.appTextDark.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: app.appTextDark,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // tutup drawer
          onTap();
        },
      ),
    ),
  );
}
