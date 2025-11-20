import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart';

enum DetailBgStyle { announcement, event, custom }

class CustomDetailBackground extends StatelessWidget {
  const CustomDetailBackground({
    super.key,
    this.style = DetailBgStyle.announcement,
    this.baseColor,
    this.shapeColor,
    this.padding = const EdgeInsets.all(16),
    this.child,
  });
  final DetailBgStyle style;
  final Color? baseColor;
  final Color? shapeColor;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  // Colors type
  (Color base, Color shape) _resolveColors() {
    switch (style) {
      case DetailBgStyle.announcement:
        return (baseColor ?? appPrimaryMain, shapeColor ?? appPrimaryHover);
      case DetailBgStyle.event:
        return (baseColor ?? appSecondaryMain, shapeColor ?? appSecondaryLight);
      case DetailBgStyle.custom:
        return (baseColor ?? appPrimaryMain, shapeColor ?? appPrimaryHover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (base, shape) = _resolveColors();
    final waveColor = style == DetailBgStyle.event ? appSecondaryHover : shape;
    return ColoredBox(
      color: base,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  children: [
                    // Top wave
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/shapes/wave.png',
                        fit: BoxFit.fitWidth,
                        color: waveColor,
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                    // Bottom wave
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/shapes/wave6.png',
                        fit: BoxFit.fitWidth,
                        color: waveColor,
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (child != null)
            SafeArea(
              child: Padding(padding: padding, child: child),
            ),
        ],
      ),
    );
  }
}
