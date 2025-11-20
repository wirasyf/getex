import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.enabled = true,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;
  final bool enabled;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? app.appInfoDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? app.appTextSecond,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(
                color: textColor ?? app.appTextSecond,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    ),
  );
}
