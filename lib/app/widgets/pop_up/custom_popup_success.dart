import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/constant/colors/colors.dart' as app;

/// Enum untuk tipe popup
enum PopupType { success, info }

/// A reusable popup with Lottie animation
///
/// Examples:
///
/// Success popup:
/// await CustomPopup.show(
///   context,
///   type: PopupType.success,
///   title: 'Sukses mengatur titik rumah',
///   subtitle: 'klik tutup untuk lanjut',
///   lottieAsset: 'assets/lottie/success.json',
/// );
///
/// Info popup:
/// await CustomPopup.show(
///   context,
///   type: PopupType.info,
///   title: 'Data Pembayaran Telah dikirim!',
///   subtitle: 'menunggu verifikasi',
///   lottieAsset: 'assets/lottie/info.json',
/// );
class CustomPopup extends StatelessWidget {
  const CustomPopup({
    required this.type,
    required this.title,
    required this.lottieAsset,
    super.key,
    this.subtitle = '',
    this.buttonText = 'Tutup',
    this.onClose,
  });
  final PopupType type;
  final String title;
  final String subtitle;
  final String buttonText;
  final String lottieAsset;
  final VoidCallback? onClose;

  static Future<void> show(
    BuildContext context, {
    required PopupType type,
    required String title,
    required String lottieAsset,
    String subtitle = '',
    String buttonText = 'Tutup',
    VoidCallback? onClose,
    bool barrierDismissible = false,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomPopup(
        type: type,
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        lottieAsset: lottieAsset,
        onClose: onClose,
      ),
    );
  }

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
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie Animation
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    lottieAsset,
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

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
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.bodyMedium?.copyWith(
                          color: app.appTextKet,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ) ??
                        const TextStyle(
                          color: app.appTextKet,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],

                const SizedBox(height: 20),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClose?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == PopupType.success
                          ? app.appPrimaryMain
                          : app.appInfoDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: app.appTextSecond,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
