import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/menu/profile_menu.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: app.appInfoHover,
    body: Column(
      children: [
        // Header profile
        Container(
          width: double.infinity,
          height: 260,
          color: app.appInfoHover,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none, // vertikal bisa overflow
                children: [
                  // Gambar atas
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      width: w*0.95, // jangan lebih dari maxWidth
                      child: Image.asset(
                        'assets/shapes/wave.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  // Gambar bawah
                  Positioned(
                    bottom: -15, // geser sedikit ke bawah
                    left: 0,
                    child: SizedBox(
                      width: w, // tetap maksimal sama dengan container
                      child: Image.asset(
                        'assets/shapes/wave4.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  // Avatar & teks
                  Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: const Offset(0, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: app.appBackgroundMain,
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: app.appTextKet,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => Text(
                              controller.username.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: app.appTextSecond,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              controller.email.value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: app.appTextLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // List menu
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: app.appBackgroundForm,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/location.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appSuccessLight,
                  title: 'Lihat Lokasi',
                  subtitle: 'Lihat lokasi anda saat ini',
                  onTap: controller.goToLocation,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/history.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appSuccessLight,
                  title: 'Riwayat transaksi',
                  subtitle: 'Lihat transaksi yang telah anda lakukan',
                  onTap: controller.goToPaymentHistory,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/edit.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appInfoLight,
                  title: 'Ubah profil',
                  subtitle: 'Ubah foto profil dan password anda',
                  onTap: controller.goToEditProfile,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/lock.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appInfoLight,
                  title: 'Ubah Kata sandi',
                  subtitle: 'Ubah kata sandi anda',
                  onTap: controller.goToEditPassword,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/terms.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appSecondaryLight,
                  title: 'Syarat dan ketentuan',
                  subtitle: 'Baca aturan penggunaan aplikasi ini',
                  onTap: controller.goToTerms,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/faq.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appPendingLight,
                  title: 'Faq',
                  subtitle: 'Pertanyaan yang sering diajukan',
                  onTap: controller.goToFaq,
                ),
                ProfileMenuItem(
                  icon: Image.asset(
                    'assets/icons/logout.png',
                    width: 24,
                    height: 24,
                  ),
                  color: app.appErrorLight,
                  title: 'Keluar',
                  subtitle: 'Keluar dari akun ini',
                  onTap: controller.logout,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
