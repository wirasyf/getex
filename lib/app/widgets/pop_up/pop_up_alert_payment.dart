import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/colors/colors.dart' as app;

void showPaymentDialog(
  BuildContext context, {
  required String title,
  required String amount,
  required String month,
  required String status,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: app.appBackgroundMain,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: app.appTextDark,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: app.appNeutralLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: app.appTextKet,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount
            Center(
              child: Text(
                amount,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: app.appErrorMain,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Rincian
            const Text(
              'Rincian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: app.appTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: app.appTextDark,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Bulan $month',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: app.appTextDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: app.appTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: app.appTextDark,
              ),
            ),
            const SizedBox(height: 32),

            // Bayar sekarang button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Tambahkan logika pembayaran di sini
                  Get.snackbar(
                    'Pembayaran',
                    'Fitur pembayaran akan segera tersedia',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: app.appPrimaryMain,
                    colorText: app.appTextSecond,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: app.appErrorMain,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Bayar sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: app.appTextSecond,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
