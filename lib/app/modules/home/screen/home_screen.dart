import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../routes/app_pages.dart';
import '../../../widgets/card/custom_card.dart';
import '../../../widgets/navigation/custom_bottom_bar.dart';
import '../../../widgets/navigation/custom_sidebar.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../../../widgets/pop_up/pop_up_alert_payment.dart';
import '../../details/controllers/details_controller.dart';
import '../../details/screen/detail_announcement.dart';
import '../../details/screen/detail_event.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../../payment/controllers/payment_controller.dart';
import '../../payment/screen/payment_screen.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/screen/profile_screen.dart';
import '../../report/controllers/report_controller.dart';
import '../../report/screen/report_screen.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    Get
      ..put(ReportController())
      ..put(ProfileController())
      ..put(PaymentController())
      ..put(DetailsController());

    // List pages bottom bar
    final pages = <Widget>[
      _buildHomePage(context),
      const PaymentView(),
      const ReportView(),
      const ProfileView(),
    ];

    // Show popup kalo dari input map
    final args = Get.arguments;
    if (args != null && args['showSuccessPopup'] == true) {
      Future.microtask(() async {
        await CustomPopup.show(
          // ignore: use_build_context_synchronously
          context,
          type: PopupType.success,
          title: 'Sukses mengatur titik rumah',
          subtitle: 'Klik tutup untuk lanjut',
          lottieAsset: 'assets/lottie/success.json',
        );
      });
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Obx(
        () => Scaffold(
          backgroundColor: app.appBackgroundMain,
          drawer: navController.currentIndex.value == 0
              ? const SideBar()
              : null,
          body: PageView(
            controller: navController.pageController,
            onPageChanged: navController.onPageChanged,
            children: pages,
          ),
          bottomNavigationBar: const CustomBottomBar(),
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) => SafeArea(
    top: false,
    child: SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(controller),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat datang, Joko',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: app.appTextDark,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFamilySection(controller),
                const SizedBox(height: 24),
                _buildAlertsSection(context, controller),
                const SizedBox(height: 24),
                _buildAnnouncementsSection(controller),
                const SizedBox(height: 24),
                _buildEventsSection(controller),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // Header
  Widget _buildHeader(HomeController controller) => ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
    child: Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [app.appInfoHover, app.appInfoHover.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/shapes/wave.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: app.appBackgroundMain.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: app.appTextSecond,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Info user
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: app.appBackgroundMain,
                      child: Icon(
                        Icons.person,
                        color: app.appPrimaryMain,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userName.value,
                              style: const TextStyle(
                                color: app.appTextSecond,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              controller.userEmail.value,
                              style: TextStyle(
                                color: app.appTextSecond.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Notif button
                    InkWell(
                      onTap: () => Get.toNamed(Routes.NOTIFICATION),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: app.appBackgroundMain.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications_rounded,
                                color: app.appTextSecond,
                                size: 22,
                              ),
                            ),
                            // Badge dot
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: app.appErrorMain,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // Anggota keluarga
  Widget _buildFamilySection(HomeController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Anggota keluarga',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: app.appTextDark,
            ),
          ),
          TextButton(
            onPressed: controller.viewAllFamily,
            child: const Text(
              'Lihat detail',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: app.appPrimaryMain,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 8),
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
        child: Obx(
          () => ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemCount: controller.familyMembers.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.familyMembers.length) {
                final member = controller.familyMembers[index];
                return _buildFamilyMemberChip(
                  member.initials,
                  member.name,
                  member.color,
                );
              } else {
                return _buildAddMemberChip(controller);
              }
            },
          ),
        ),
      ),
    ],
  );

  Widget _buildFamilyMemberChip(String initials, String name, Color color) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: app.appTextDark,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  // Add member
  Widget _buildAddMemberChip(HomeController controller) => GestureDetector(
    onTap: controller.addFamilyMember,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: app.appPrimaryMain.withValues(alpha: 0.1),
            border: Border.all(color: app.appPrimaryMain, width: 2),
          ),
          child: const Icon(Icons.add, color: app.appPrimaryMain),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tambah',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: app.appTextDark,
          ),
        ),
      ],
    ),
  );

  // Tunggakan pembayaran
  Widget _buildAlertsSection(BuildContext context, HomeController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tunggakan Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: app.appTextDark,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => showPaymentDialog(
              context,
              title: 'Tunggakan pembayaran!',
              amount: 'Rp.50.000',
              month: 'Oktober',
              status: 'Belum lunas',
            ),
            child: const AlertCard(
              title: 'Tunggakan pembayaran!',
              subtitle: 'Senilai\nRp.50.000',
              rtText: 'RT 10',
            ),
          ),
        ],
      );

  // Pengumuman terbaru
  Widget _buildAnnouncementsSection(HomeController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _buildSectionHeader(
        'Pengumuman Terbaru',
        controller.viewAllAnnouncements,
      ),
      const SizedBox(height: 12),
      AnnouncementCard(
        title: 'Tahlilan malam jumat',
        subtitle: 'Pada pukul\n18.00 WIB',
        rtText: 'RT 10',
        onTap: () {
          Get.to(
            () => const DetailsAnnouncementPage(),
            arguments: {
              'title': 'Tahlilan malam jumat',
              'subtitle':
                  'Diharapkan datang dikediaman pak mamat senabis magrib untuk membacakan yasin & tahlil',
              'rtText': 'RT 10',
              'dateTime': 'Pada pukul 18.00 WIB',
              'location': 'Rumah Pak Mamat',
              'description':
                  'Diharapkan datang dikediaman pak mamat senabis magrib untuk membacakan yasin & tahlil',
            },
          );
        },
      ),
      AnnouncementCard(
        title: 'Gotong royong',
        subtitle: 'Pada pukul\n07.00 WIB',
        rtText: 'RT 10',
        onTap: () {
          Get.to(
            () => const DetailsAnnouncementPage(),
            arguments: {
              'title': 'Gotong royong',
              'subtitle': 'Kegiatan gotong royong bersama warga RT 10',
              'rtText': 'RT 10',
              'dateTime': 'Pada pukul 07.00 WIB',
              'location': 'Lingkungan RT 10',
              'description':
                  'Kegiatan gotong royong rutin untuk membersihkan lingkungan RT 10. Semua warga diharapkan berpartisipasi.',
            },
          );
        },
      ),
    ],
  );

  // Event terbaru
  Widget _buildEventsSection(HomeController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionHeader('Event Terbaru', controller.viewAllEvents),
      const SizedBox(height: 12),
      EventCard(
        title: 'Lomba 17 Agustus',
        subtitle: 'Rentan acara\n01-20 Agustus 2025',
        rtText: 'RT 10',
        onTap: () {
          Get.to(
            () => const DetailsEventPage(),
            arguments: {
              'title': 'Lomba 17 Agustus',
              'subtitle':
                  'Diharapkan seluruh warga rt 10 ikut serta dalam kegiatan lomba 17 agustus.',
              'rtText': 'RT 10',
              'dateTime': 'Rentan acara 01-20 Agustus 2025',
              'location': 'Lapangan RT 10',
              'description':
                  'Kegiatan lomba 17 Agustus meliputi berbagai perlombaan tradisional untuk memeriahkan hari kemerdekaan. Semua warga diharapkan berpartisipasi.',
            },
          );
        },
      ),
      EventCard(
        title: 'Sedekah Bumi',
        subtitle: 'Rentan acara\n02-04 September 2025',
        rtText: 'RT 10',
        onTap: () {
          Get.to(
            () => const DetailsEventPage(),
            arguments: {
              'title': 'Sedekah Bumi',
              'subtitle': 'Acara sedekah bumi untuk mensyukuri hasil panen',
              'rtText': 'RT 10',
              'dateTime': 'Rentan acara 02-04 September 2025',
              'location': 'Balai RT 10',
              'description':
                  'Acara sedekah bumi sebagai wujud syukur atas hasil panen. Semua warga diharapkan hadir dan berpartisipasi.',
            },
          );
        },
      ),
    ],
  );

  // Header section dengan button lihat semua
  Widget _buildSectionHeader(String title, VoidCallback onPressed) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: app.appTextDark,
        ),
      ),
      TextButton(
        onPressed: onPressed,
        child: const Text(
          'Lihat semua',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: app.appPrimaryMain,
          ),
        ),
      ),
    ],
  );
}
