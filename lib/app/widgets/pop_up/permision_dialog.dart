import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/core/constant/colors/colors.dart' as app;

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    super.key,
    this.title = 'Konfirmasi',
    required this.content,
    this.confirmText = 'Izinkan',
    this.cancelText = 'Tolak',
  });

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  /// Menampilkan dialog dengan blur background dan mengembalikan Future<bool>
  static Future<bool?> show({
    required String content,
    String title = 'Konfirmasi',
    String confirmText = 'Izinkan',
    String cancelText = 'Tolak',
  }) => Get.dialog<bool>(
    Stack(
      children: [
        // Blur background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.3), // semi transparan
            ),
          ),
        ),
        Center(
          child: PermissionDialog(
            title: title,
            content: content,
            confirmText: confirmText,
            cancelText: cancelText,
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16), // margin content
    backgroundColor: app.appBackgroundMain,
    title: Text(
      title,
      style: const TextStyle(
        color: app.appTextDark,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    content: Text(
      content,
      style: const TextStyle(color: app.appTextDark, fontSize: 16),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    actions: [
      TextButton(
        onPressed: () => Get.back(result: false),
        style: TextButton.styleFrom(foregroundColor: app.appTextDark),
        child: Text(cancelText),
      ),
      ElevatedButton(
        onPressed: () => Get.back(result: true),
        style: ElevatedButton.styleFrom(backgroundColor: app.appPrimaryMain),
        child: Text(confirmText, style: const TextStyle(color: Colors.white)),
      ),
    ],
  );
}
