import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/service/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashSmartController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController stage1Controller;
  late AnimationController stage2Controller;
  late AnimationController stage2bController;
  late AnimationController stage3Controller;
  late AnimationController stage4Controller;

  late Animation<double> rtOpacity;
  late Animation<double> rtScale;
  late Animation<double> rtShift;
  late Animation<double> smaOpacity;
  late Animation<double> containerSize;
  late Animation<double> colorTransition;
  late Animation<double> scaleWidth;
  late Animation<double> scaleHeight;
  late Animation<double> borderRadius;

  final showRestartButton = false.obs;
  final StorageService _storageService = Get.find<StorageService>();

  // Method _checkAndNavigate() sudah benar.
  Future<void> _checkAndNavigate() async {
    // 1. Cek status Onboarding
    final isOnboardingComplete = await _storageService.getOnboardingStatus();

    if (!isOnboardingComplete) {
      // 🎯 KASUS 1: Onboarding BELUM selesai
      Get.offAllNamed(Routes.ON_BOARDING);
      if (kDebugMode) print('🧭 Navigating to ONBOARDING');
    } else {
      // 2. Jika Onboarding SUDAH selesai, cek status Login
      final bool isLoggedIn = await _storageService.isLoggedIn();

      if (isLoggedIn) {
        // 🎯 KASUS 2: Sudah Onboarding & SUDAH Login
        Get.offAllNamed(Routes.HOME);
        if (kDebugMode) print('🧭 Navigating to HOME');
      } else {
        // 🎯 KASUS 3: Sudah Onboarding & BELUM Login
        Get.offAllNamed(Routes.LOGIN);
        if (kDebugMode) print('🧭 Navigating to LOGIN');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initAnimations();
    startAnimation();
  }

  void _initAnimations() {
    // Stage 1: RT Logo fade in & zoom
    stage1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    rtOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: stage1Controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    rtScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: stage1Controller, curve: Curves.easeOutBack),
    );

    // Stage 2: RT Logo shift
    stage2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    rtShift = Tween<double>(begin: 0.0, end: 37.0).animate(
      CurvedAnimation(parent: stage2Controller, curve: Curves.easeInOut),
    );

    // Stage 2b: SMA Logo fade in
    stage2bController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    smaOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: stage2bController, curve: Curves.easeIn));

    // Stage 3: Container expand & color transition
    stage3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    containerSize = Tween<double>(
      begin: 0.0,
      end: 300.0,
    ).animate(CurvedAnimation(parent: stage3Controller, curve: Curves.easeOut));

    colorTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: stage3Controller,
        curve: const Interval(0.2, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    // Stage 4: Full screen expand (DIPERCEPAT)
    stage4Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // Dari 900ms jadi 400ms
    );

    scaleWidth = Tween<double>(
      begin: 1.0,
      end: 7.0,
    ).animate(CurvedAnimation(parent: stage4Controller, curve: Curves.easeIn));

    scaleHeight = Tween<double>(
      begin: 1.0,
      end: 60.0,
    ).animate(CurvedAnimation(parent: stage4Controller, curve: Curves.easeIn));

    borderRadius = Tween<double>(begin: 150.0, end: 0.0).animate(
      CurvedAnimation(
        parent: stage4Controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut), // Lebih cepat
      ),
    );
  }

  Future<void> startAnimation() async {
    // Initial delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Stage 1: RT Logo appears
    await stage1Controller.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // Stage 2: RT Logo shifts
    await stage2Controller.forward();
    await Future.delayed(const Duration(milliseconds: 150));

    // Stage 2b: SMA Logo appears
    await stage2bController.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // Stage 3: Container expands
    await stage3Controller.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // Stage 4: Quick transition (hanya 400ms)
    await stage4Controller.forward();

    // Langsung navigasi tanpa delay tambahan
    await _checkAndNavigate();
  }

  void restartAnimation() {
    showRestartButton.value = false;

    stage1Controller.reset();
    stage2Controller.reset();
    stage2bController.reset();
    stage3Controller.reset();
    stage4Controller.reset();

    startAnimation();
  }

  @override
  void onClose() {
    stage1Controller.dispose();
    stage2Controller.dispose();
    stage2bController.dispose();
    stage3Controller.dispose();
    stage4Controller.dispose();
    super.onClose();
  }
}
