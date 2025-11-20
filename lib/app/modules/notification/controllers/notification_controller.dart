import 'package:get/get.dart';
import '../../../data/models/notifikasi.dart';
import '../../../routes/app_pages.dart';

class NotificationController extends GetxController {
  // Notif berdasarkan waktu
  final todayNotifications = <NotificationModel>[].obs;
  final yesterdayNotifications = <NotificationModel>[].obs;
  final lastWeekNotifications = <NotificationModel>[].obs;
  final notification = Rx<NotificationModel?>(null);
  final Rx<NotificationModel?> selectedNotification = Rx<NotificationModel?>(
    null,
  );

  final String greeting = 'Halo warga RT 10 👋';
  final String message =
      'Kami hanya ingin mengingatkan kembali bahwa malam ini akan diadakan tahlilan rutin dirumah pak mamat mulai pukul 18.00 WIB. '
      'Jangan lupa untuk meluangkan waktu dan hadir tepat waktu agar acara bisa dimulai sesuai jadwal.\n\n'
      'Bagi warga yang biasanya membantu perlengkapan atau konsumsi, mohon diatur sedikit lebih awal ya. '
      'Sampai jumpa malam ini, semoga kita semua diberi kesehatan dan kelancaran dalam kegiatan ini. 🙏';

  bool get hasNotifications =>
      todayNotifications.isNotEmpty ||
      yesterdayNotifications.isNotEmpty ||
      lastWeekNotifications.isNotEmpty;

  int get unreadCount {
    var count = 0;
    count += todayNotifications.where((n) => !n.isRead).length;
    count += yesterdayNotifications.where((n) => !n.isRead).length;
    count += lastWeekNotifications.where((n) => !n.isRead).length;
    return count;
  }

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    if (Get.arguments != null && Get.arguments is NotificationModel) {
      selectedNotification.value = Get.arguments as NotificationModel;
    }
  }

  void loadNotifications() {
    todayNotifications.value = [
      NotificationModel(
        id: '1',
        title: 'Tahlilan malam jumat',
        time: '34 menit yang lalu',
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Halooo, jangan lupa untuk mengikuti lomba 17 Agustus',
        time: '1 jam yang lalu',
        isRead: false,
      ),
    ];

    yesterdayNotifications.value = [
      NotificationModel(
        id: '3',
        title: 'Halooo, jangan lupa untuk tahlilan malam ini!',
        time: '1 hari yang lalu',
        isRead: false,
      ),
      NotificationModel(
        id: '4',
        title: 'Halooo, jangan lupa untuk mengikuti lomba 17 Agustus',
        time: '1 hari yang lalu',
        isRead: true,
      ),
    ];

    lastWeekNotifications.value = [
      NotificationModel(
        id: '5',
        title: 'Halooo, jangan lupa untuk tahlilan malam ini!',
        time: '1 minggu yang lalu',
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        title: 'Halooo, jangan lupa untuk mengikuti lomba 17 Agustus',
        time: '1 minggu yang lalu',
        isRead: true,
      ),
    ];
  }

  void markAsRead(String id) {
    final todayIndex = todayNotifications.indexWhere((n) => n.id == id);
    if (todayIndex != -1) {
      todayNotifications[todayIndex] = todayNotifications[todayIndex].copyWith(
        isRead: true,
      );
      return;
    }

    final yesterdayIndex = yesterdayNotifications.indexWhere((n) => n.id == id);
    if (yesterdayIndex != -1) {
      yesterdayNotifications[yesterdayIndex] =
          yesterdayNotifications[yesterdayIndex].copyWith(isRead: true);
      return;
    }

    final lastWeekIndex = lastWeekNotifications.indexWhere((n) => n.id == id);
    if (lastWeekIndex != -1) {
      lastWeekNotifications[lastWeekIndex] =
          lastWeekNotifications[lastWeekIndex].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    todayNotifications.value = todayNotifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    yesterdayNotifications.value = yesterdayNotifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    lastWeekNotifications.value = lastWeekNotifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
  }

  void deleteNotification(String id) {
    todayNotifications.removeWhere((n) => n.id == id);
    yesterdayNotifications.removeWhere((n) => n.id == id);
    lastWeekNotifications.removeWhere((n) => n.id == id);
  }

  void openNotificationDetail(NotificationModel notification) {
    markAsRead(notification.id);
    selectedNotification.value = notification;
    Get.toNamed(Routes.DETAIL_NOTIFICATION, arguments: notification);
  }
}
