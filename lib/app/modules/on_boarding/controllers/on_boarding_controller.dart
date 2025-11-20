import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/service/storage_service.dart';
import '../../../routes/app_pages.dart';

class OnBoardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  // Data onboarding
  final List<String> images = const [
    'assets/image/1.png',
    'assets/image/2.png',
    'assets/image/3.png',
  ];

  final List<String> titles = const [
    'Selamat Datang di Smart RT!',
    'Pantau pemasukan & pengeluaran',
    'Pengumuman lebih cepat & mudah',
  ];

  final List<String> subtitles = const [
    'Smart RT, Aplikasi andalan untuk pencatatan dan pembayaran kas RT. Lebih praktis, transparan, dan aman di genggaman Anda',
    'Pantau pemasukan dan pengeluaran kas RT secara real-time. Semua data keuangan ditampilkan secara transparan dan mudah dipahami oleh warga.',
    'Smart RT, Aplikasi andalan untuk pencatatan dan pembayaran kas RT. Lebih praktis, transparan, dan aman di genggaman Anda',
  ];

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  // ignore: use_setters_to_change_properties
  void onPageChanged(int index) => currentPage.value = index;

  void nextPage() {
    if (currentPage.value < images.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> finishOnboarding() async {
    // 🎯 SIMPAN STATUS ONBOARDING TELAH SELESAI
    await _storageService.saveOnboardingStatus(isComplete: true);

    // NAVIGASI KE LOGIN (atau Home, tergantung alur Anda)
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
