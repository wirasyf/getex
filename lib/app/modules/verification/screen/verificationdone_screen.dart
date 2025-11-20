import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/verification_controller.dart';

class VerificationdoneView extends GetView<VerificationController> {
  const VerificationdoneView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: appBackgroundMain,
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SuccessIllustration(),
                  SizedBox(height: 24),
                  Text(
                    'Data sudah diverifikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: appTextMain,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'lanjut untuk mengisi  alamat rumah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: appTextSecond,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.INPUT_MAP),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appPrimaryMain,
                  foregroundColor: appTextLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Lanjutkan'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SuccessIllustration extends StatelessWidget {
  const _SuccessIllustration();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final imgHeight = (width * 0.6).clamp(220.0, 300.0);
    return Image.asset(
      'assets/ilustration/doc.png',
      height: imgHeight,
      fit: BoxFit.contain,
    );
  }
}
