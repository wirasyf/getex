import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart';
import '../controllers/verification_controller.dart';

class PendingView extends StatefulWidget {
  const PendingView({super.key});

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  @override
  void initState() {
    super.initState();
    // Delegasikan navigasi ke controller terpusat
    Get.find<VerificationController>().onEnterPending();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: appBackgroundMain,
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration
                Image.asset(
                  'assets/ilustration/time.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Harap tunggu sebentar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: appTextMain,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'data anda sedang divalidasi oleh rt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: appTextDark,
                  ),
                ),
              ],
            ),
          ),
          // Bottom status bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: appPrimaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Menunggu verifikasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appTextMain,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(appTextMain),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
