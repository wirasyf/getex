import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class AddReportButton extends StatelessWidget {
  const AddReportButton({
    required this.onTap,
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });
  final VoidCallback onTap;
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 56.0;
    final bgColor = backgroundColor ?? app.appPrimaryHover;
    final iColor = iconColor ?? app.appTextSecond;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Wave overlay at top, clipped to the same radius
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/shapes/wave_pluss.png',
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
              // Plus icon on top
              Center(
                child: Icon(Icons.add, color: iColor, size: buttonSize * 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
