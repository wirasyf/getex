import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../../payment/controllers/payment_controller.dart';

class DetailPaymentHistoryScreen extends StatelessWidget {
  DetailPaymentHistoryScreen({super.key});
  final PaymentController controller = Get.find<PaymentController>();

  @override
  // Header
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Detail transaksi',
            ),
          ),

          // Konten
          Positioned.fill(
            top: headerH * 0.70,
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Month indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedPaymentItem.value?.title ??
                              'September',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: app.appTextDark,
                          ),
                        ),
                        const Text(
                          '18:30 WIB',
                          style: TextStyle(fontSize: 14, color: app.appTextKet),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Receipt Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: app.appBackgroundForm,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/image/selokan.png',
                        fit: BoxFit.cover,
                        height: 250,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Payment type indicator
                    Obx(() {
                      final selectedItem = controller.selectedPaymentItem.value;
                      final isBulanan =
                          selectedItem?.description.contains('bulanan') ?? true;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBulanan ? 'Bulan' : 'Opsi Pembayaran',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: app.appTextDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: app.appBackgroundMain,
                              border: Border.all(color: app.appNeutralLight),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              selectedItem?.title ?? 'September',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: app.appTextDark,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    /// Nominal Field
                    const Text(
                      'Nominal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: app.appTextDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.nominalController
                        ..text =
                            controller.selectedPaymentItem.value?.amount ??
                            'Rp. 50.000',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Rp. 50.000',
                        hintStyle: const TextStyle(color: app.appTextKet),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: app.appNeutralLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: app.appNeutralLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: app.appPrimaryMain,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => controller.nominal.value = value,
                    ),
                    const SizedBox(height: 32),

                    /// Status bar
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: controller.submitTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: app.appSuccessMain,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Berhasil',
                          style: TextStyle(
                            color: app.appTextSecond,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
