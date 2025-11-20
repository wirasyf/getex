import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../controllers/notification_controller.dart';

class NotificationDetailView extends GetView<NotificationController> {
  const NotificationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: 'Detail Notifikasi',
            ),
          ),

          // Konten utama
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildNotificationCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() => Obx(() {
    final notif = controller.selectedNotification.value;
    if (notif == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: app.appTextDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: app.appInfoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/icons/clock.png',
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: app.appTextMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: app.appTextKet,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: app.appNeutralLight),
          const SizedBox(height: 20),
          Text(
            controller.greeting,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: app.appTextMain,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.message,
            style: const TextStyle(
              fontSize: 14,
              color: app.appTextKet,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  });
}
