import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class CodeInputField extends StatelessWidget {
  const CodeInputField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 60,
    height: 60,
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: app.appNeutralMain, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: app.appNeutralMain, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: app.appPrimaryMain, width: 2),
        ),
        filled: true,
        fillColor: app.appBackgroundMain,
      ),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: app.appTextDark,
      ),
    ),
  );
}
