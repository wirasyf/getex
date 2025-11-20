import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

// Reusable TextField
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hint,
    required this.controller,
    super.key,
    this.obscureText = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.backgroundColor,
  });
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  //togle visibility
  @override
  Widget build(BuildContext context) {
    final isPasswordField = onVisibilityToggle != null;
    return TextField(
      controller: controller,
      obscureText: isPasswordField ? !isPasswordVisible : obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: app.appTextKet),
        filled: true,
        fillColor: backgroundColor ?? app.appBackgroundMain,
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: app.appTextKet,
                ),
                onPressed: onVisibilityToggle,
              )
            : suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: app.appBackgroundMain),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: app.appNeutralLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: app.appPrimaryMain, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}