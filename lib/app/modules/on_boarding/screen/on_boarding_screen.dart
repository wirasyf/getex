import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../routes/app_pages.dart';
import '../controllers/on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: app.appInfoDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              _buildHeader(size),
              _buildImageCarousel(size),
              const SizedBox(height: 20),
              _buildDotsIndicator(),
              const SizedBox(height: 24),
              _buildTextSection(size),
              const Spacer(),
              _buildActionButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(Size size) => SizedBox(
    height: size.height * 0.1,
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/logo_smart.png',
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.image_not_supported_outlined,
              color: app.appBackgroundMain,
              size: 48,
            ),
          ),
        ],
      ),
    ),
  );

  // Image carousel
  Widget _buildImageCarousel(Size size) => SizedBox(
    height: size.height * 0.45,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: PageView.builder(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.images.length,
        itemBuilder: (_, i) => Image.asset(
          controller.images[i],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: app.appBackgroundSecond,
            child: const Icon(Icons.photo, color: app.appTextDark, size: 72),
          ),
        ),
      ),
    ),
  );

  // Dots indicator
  Widget _buildDotsIndicator() => Obx(() {
    final current = controller.currentPage.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.images.length, (i) {
        final active = current == i;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 10 : 6,
          height: active ? 10 : 6,
          decoration: BoxDecoration(
            color: active
                ? app.appBackgroundMain
                : app.appInfoLight.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  });

  // Title & subtitle section
  Widget _buildTextSection(Size size) {
    final baseText = size.width < 360 ? 0.9 : 1.0;
    return Obx(() {
      final index = controller.currentPage.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.titles[index],
            style: TextStyle(
              color: app.appBackgroundMain,
              fontSize: 22 * baseText,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.subtitles[index],
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: app.appTextLight,
              fontSize: 14 * baseText,
              height: 1.4,
            ),
          ),
        ],
      );
    });
  }

  // Action button
  Widget _buildActionButton() => Obx(() {
    final isLast = controller.currentPage.value == controller.images.length - 1;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (isLast) {
            Get.offAllNamed(Routes.LOGIN);
          } else {
            controller.nextPage();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: app.appBackgroundMain,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          isLast ? 'Mulai' : 'Lanjut',
          style: const TextStyle(
            color: app.appTextDark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  });
}
