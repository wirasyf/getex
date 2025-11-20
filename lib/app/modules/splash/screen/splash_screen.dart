import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/modules/splash/controllers/splash_controller.dart';

class SplashSmartScreen extends GetView<SplashSmartController> {
  const SplashSmartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Container biru
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                controller.stage3Controller,
                controller.stage4Controller,
              ]),
              builder: (context, child) {
                double size = controller.containerSize.value;
                double scaleX = controller.scaleWidth.value;
                double scaleY = controller.scaleHeight.value;
                double borderRadius = controller.borderRadius.value;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(scaleX, scaleY),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0DA6D6),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                );
              },
            ),
          ),

          // Logo smart
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                controller.stage1Controller,
                controller.stage2Controller,
                controller.stage2bController,
                controller.stage3Controller,
                controller.stage4Controller,
              ]),
              builder: (context, child) {
                Color logoColor = Color.lerp(
                  const Color(0xFF0DA6D6),
                  Colors.white,
                  controller.colorTransition.value,
                )!;

                double logoOpacity = controller.stage4Controller.value > 0.3
                    ? (1.0 - ((controller.stage4Controller.value - 0.3) / 0.7))
                          .clamp(0.0, 1.0)
                    : 1.0;

                return Opacity(
                  opacity: logoOpacity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Logo RT - Dengan zoom in bounce effect
                      Transform.translate(
                        offset: Offset(controller.rtShift.value + 15, -3),
                        child: Transform.scale(
                          scale: controller.rtScale.value,
                          child: Opacity(
                            opacity: controller.rtOpacity.value,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                logoColor,
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(
                                'assets/image/rt.png',
                                width: 219,
                                height: 71,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Logo SMA
                      Transform.translate(
                        offset: const Offset(-33.0, 0),
                        child: Opacity(
                          opacity: controller.smaOpacity.value,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              logoColor,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/image/sma.png',
                              width: 180,
                              height: 34,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Tombol restart untuk TESTING ONLY (uncomment jika perlu)
          /*
          Obx(() {
            if (!controller.showRestartButton.value) return const SizedBox();
            
            return Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: controller.restartAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0DA6D6),
                  ),
                  child: const Text('Restart Animation'),
                ),
              ),
            );
          }),
          */
        ],
      ),
    );
  }
}
