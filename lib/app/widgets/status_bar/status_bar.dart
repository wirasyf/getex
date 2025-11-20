import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({required this.text, super.key});
  final String text;

  //status bar card
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: appPrimaryLight,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: appTextMain,
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(appTextMain),
          ),
        ),
      ],
    ),
  );
}
