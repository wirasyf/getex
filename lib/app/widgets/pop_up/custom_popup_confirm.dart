import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class CustomConfirmationPopup extends StatelessWidget {
  // warna tombol YA

  const CustomConfirmationPopup({
    required this.title,
    super.key,
    this.subtitle = '',
    this.cancelText = 'Tidak',
    this.confirmText = 'Ya',
    this.imageAsset = 'assets/ilustration/question.png',
    this.onCancel,
    this.onConfirm,
    this.confirmButtonColor = app.appErrorMain, // default merah
  });
  final String title;
  final String subtitle;
  final String cancelText;
  final String confirmText;
  final String imageAsset;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Color confirmButtonColor;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String subtitle = '',
    String cancelText = 'Tidak',
    String confirmText = 'Ya',
    String imageAsset = 'assets/ilustration/question.png',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
    Color confirmButtonColor = app.appErrorMain,
  }) async => showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => CustomConfirmationPopup(
      title: title,
      subtitle: subtitle,
      cancelText: cancelText,
      confirmText: confirmText,
      imageAsset: imageAsset,
      onCancel: onCancel,
      onConfirm: onConfirm,
      confirmButtonColor: confirmButtonColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Material(
        color: app.appBackgroundMain,
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280, maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Illustration
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Image.asset(
                    imageAsset,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      theme.textTheme.titleMedium?.copyWith(
                        color: app.appTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ) ??
                      const TextStyle(
                        color: app.appTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                ),

                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.bodyMedium?.copyWith(
                          color: app.appTextKet,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(
                          color: app.appTextKet,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],

                const SizedBox(height: 14),

                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          onCancel?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: app.appTextKet.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            color: app.appTextDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onConfirm?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmButtonColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: app.appTextSecond,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
