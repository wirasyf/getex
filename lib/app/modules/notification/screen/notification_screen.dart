import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/models/notifikasi.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

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
              title: 'Notifikasi',
            ),
          ),

          // Panel konten
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
              child: Obx(() {
                if (!controller.hasNotifications) {
                  return _buildEmptyState();
                }

                return _buildNotificationList();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/ilustration/notif_empty.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 32),
        const Text(
          'Tidak ada notifikasi',
          style: TextStyle(
            color: app.appTextMain,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Anda akan menerima notifikasi ketika ada update penting',
            textAlign: TextAlign.center,
            style: TextStyle(color: app.appTextKet, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  Widget _buildNotificationList() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                '${controller.unreadCount} notifikasi belum dibaca',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: app.appTextKet,
                ),
              ),
            )
          ],
        ),
      ),

      // Scrollable content
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.todayNotifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Terbaru'),
                    ...controller.todayNotifications.map(
                      _buildNotificationItem,
                    ),
                  ],
                );
              }),

              // Kemarin
              Obx(() {
                if (controller.yesterdayNotifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSectionTitle('Kemarin'),
                    ...controller.yesterdayNotifications.map(
                      _buildNotificationItem,
                    ),
                  ],
                );
              }),

              // 1 Minggu lalu
              Obx(() {
                if (controller.lastWeekNotifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSectionTitle('1 Minggu lalu'),
                    ...controller.lastWeekNotifications.map(
                      _buildNotificationItem,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: app.appTextMain,
      ),
    ),
  );

  Widget _buildNotificationItem(NotificationModel notification) => Dismissible(
    key: Key(notification.id),
    direction: DismissDirection.endToStart,
    background: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: app.appErrorMain,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: app.appTextSecond),
    ),
    onDismissed: (_) => controller.deleteNotification(notification.id),

    // START: Perubahan utama di sini (menggunakan Stack)
    child: Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
        top: 10,
        right: 10,
      ), // Tambahkan padding di atas dan kanan untuk badge
      child: Stack(
        clipBehavior:
            Clip.none, // Penting: memungkinkan widget keluar dari batas Stack
        children: [
          // Konten Notifikasi utama (Card)
          InkWell(
            onTap: () => controller.openNotificationDetail(notification),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(
                top: 10,
                right: 10,
              ), // Offset margin ke dalam
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: app.appTextDark.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon bell
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: app.appInfoLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/icons/clock.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: notification.isRead
                                ? app.appTextKet
                                : app.appTextMain,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.time,
                          style: const TextStyle(
                            fontSize: 11,
                            color: app.appTextKet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Badge unread dengan posisi Absolute
          if (!notification.isRead)
            Positioned(
              top: 0, // Posisi di ujung atas
              right: 0, // Posisi di ujung kanan
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: app.appErrorMain,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '!', // Mengubah dari '1' menjadi '!'
                    style: TextStyle(
                      color: app.appTextSecond,
                      fontSize:
                          12, // Sedikit diperbesar agar '!' terlihat jelas
                      fontWeight: FontWeight.w800, // Ditebalkan
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
