import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/colors/colors.dart' as app;

// Header reusable dengan wave background
class ReusableHeaderMenu extends StatelessWidget {
  const ReusableHeaderMenu({
    required this.headerH,
    required this.topPad,
    required this.title,
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.rightWidget,
    this.backgroundColor,
    this.showWave = true,
    this.waveType = 2,
  });

  /// Factory: Wave2
  factory ReusableHeaderMenu.wave2({
    required double headerH,
    required double topPad,
    required String title,
    bool showBackButton = true,
    Widget? rightWidget,
  }) => ReusableHeaderMenu(
    headerH: headerH,
    topPad: topPad,
    title: title,
    waveType: 2,
    showBackButton: showBackButton,
    rightWidget: rightWidget,
  );

  /// Factory: Wave4
  factory ReusableHeaderMenu.wave4({
    required double headerH,
    required double topPad,
    required String title,
    bool showBackButton = true,
    Widget? rightWidget,
  }) => ReusableHeaderMenu(
    headerH: headerH,
    topPad: topPad,
    title: title,
    waveType: 4,
    showBackButton: showBackButton,
    rightWidget: rightWidget,
  );
  final double headerH;
  final double topPad;
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? rightWidget;
  final Color? backgroundColor;
  final bool showWave;
  final int waveType;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: Container(color: backgroundColor ?? app.appInfoHover),
      ),

      // Wave background
      if (showWave)
        Positioned.fill(
          child: IgnorePointer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;
                final topOffset = h * 0.24;
                final waveHeight = h * 0.58;
                final waveAsset = waveType == 4
                    ? 'assets/shapes/wave4.png'
                    : 'assets/shapes/wave2.png';

                return Stack(
                  children: [
                    Positioned(
                      top: topOffset,
                      left: 0,
                      right: 0,
                      height: waveHeight,
                      child: Image.asset(
                        waveAsset,
                        fit: BoxFit.fill
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

      // Title & buttons
      Padding(
        padding: EdgeInsets.only(top: topPad / 2, left: 12, right: 12),
        child: Stack(
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: app.appTextSecond,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Tombol kembali
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: app.appBackgroundMain,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: onBackPressed ?? Get.back,
                  ),
                ),
              ),

            // Widget kanan opsional
            if (rightWidget != null)
              Align(alignment: Alignment.centerRight, child: rightWidget),
          ],
        ),
      ),
    ],
  );
}
