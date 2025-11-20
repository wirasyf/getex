import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/card/custom_payment_history_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_years.dart';
import '../controllers/payment_controller.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: 'Riwayat Transaksi',
              rightWidget: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  // Filter tahun
                  final result = await CustomFilterYears.show(
                    context,
                    initialYear: controller.selectedYear.value,
                  );
                  if (result != null) {
                    controller.selectedYear.value = result.year;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/filter.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),

          // BODY
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F7F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final items = controller.transactions;
                  if (items.isEmpty) {
                    // State kosong

                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final transaction = items[index]; // Render card transaksi

                      return GestureDetector(
                        onTap: () {
                          controller.onPaymentHistoryTap(
                            PaymentItem.fromTransaction(transaction),
                          );
                        },
                        child: TransactionCard(transaction: transaction),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // State kosong
  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/ilustration/note.png',
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.receipt_long_outlined,
            size: 120,
            color: app.appNeutralMain,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Belum ada transaksi!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: app.appTextKet,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
