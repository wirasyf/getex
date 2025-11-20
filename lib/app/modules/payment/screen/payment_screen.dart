import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/card/custom_payment_card.dart' as pc;
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_years.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key, this.useFetchingEmpty = true});
  final bool useFetchingEmpty;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.32;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Pembayaran',
              showBackButton: false,
              rightWidget: GestureDetector(
                onTap: () async {
                  // Filter tahun

                  final res = await CustomFilterYears.show(
                    context,
                    initialYear: controller.selectedYear.value,
                  );
                  if (res != null) {
                    controller.setYear(res.year);
                  }
                },
                child: Image.asset(
                  'assets/icons/filter.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),

          // Panel konten
          Positioned(
            top: headerH * 0.65,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Tab selector
                  _buildTabSelector(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (controller.payments.isEmpty) {
                        // State kosong

                        return useFetchingEmpty
                            ? _buildFetchingEmpty()
                            : _buildDefaultEmpty();
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: controller.payments.length,
                        itemBuilder: (context, index) {
                          final item =
                              controller.payments[index]; // Render card

                          return pc.CustomPaymentCard(
                            month: item.title,
                            year: item.year,
                            amount: item.amount,
                            subtitle: item.description,
                            status: _mapToCardStatus(item.status),
                            isFirst: index == 0,
                            isLast: index == controller.payments.length - 1,
                            onTap: () => controller.onPaymentTap(item),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Tombol bayar
          Positioned(
            right: 20,
            bottom: 30,
            child: GestureDetector(
              onTap: controller.onPayButtonPressed,
              child: const _PayActionButton(),
            ),
          ),
        ],
      ),
    );
  }

  // Tab selector month and once
  Widget _buildTabSelector() => Obx(
    () => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: app.appBackgroundMain,
            borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(
              BorderSide(
                color: app.appNeutralLight,
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Align(
                  alignment: controller.selectedTab.value == PaymentTab.bulanan
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Transform.translate(
                    offset: controller.selectedTab.value == PaymentTab.bulanan
                        ? const Offset(-1, 0)
                        : const Offset(1, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: app.appInfoHover,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              controller.selectedTab.value == PaymentTab.bulanan
                                  ? 12
                                  : 10,
                            ),
                            bottomLeft: Radius.circular(
                              controller.selectedTab.value == PaymentTab.bulanan
                                  ? 12
                                  : 10,
                            ),
                            topRight: Radius.circular(
                              controller.selectedTab.value ==
                                      PaymentTab.sekaliBayar
                                  ? 12
                                  : 10,
                            ),
                            bottomRight: Radius.circular(
                              controller.selectedTab.value ==
                                      PaymentTab.sekaliBayar
                                  ? 12
                                  : 10,
                            ),
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/shapes/wave_index.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TabButton(
                    text: 'Bulanan',
                    isSelected:
                        controller.selectedTab.value == PaymentTab.bulanan,
                    onTap: () => controller.switchTab(PaymentTab.bulanan),
                    isLeft: true,
                  ),
                  const SizedBox(width: 12),
                  _TabButton(
                    text: 'Sekali bayar',
                    isSelected:
                        controller.selectedTab.value == PaymentTab.sekaliBayar,
                    onTap: () => controller.switchTab(PaymentTab.sekaliBayar),
                    isLeft: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // State kosong default
  Widget _buildDefaultEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/ilustration/wallet.png',
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.payment_outlined,
            size: 120,
            color: app.appNeutralMain,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Belum ada tagihan!',
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

  // State kosong (fetching)
  Widget _buildFetchingEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/ilustration/wallet.png',
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.payment_outlined,
            size: 120,
            color: app.appNeutralMain,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Belum ada tagihan!',
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

  // Map status ke enum card
  pc.PaymentStatus _mapToCardStatus(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.belumLunas:
        return pc.PaymentStatus.unpaid;
      case PaymentStatus.proses:
        return pc.PaymentStatus.pending;
      case PaymentStatus.lunas:
        return pc.PaymentStatus.paid;
    }
  }
}

// Button tab selector
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isLeft = false,
  });
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Transform.translate(
        offset: isLeft ? const Offset(10, 0) : const Offset(5, 0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? app.appTextSecond : app.appTextDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

// pay button
class _PayActionButton extends StatelessWidget {
  const _PayActionButton();

  @override
  Widget build(BuildContext context) {
    const double w = 124;
    const double h = 46;
    final radius = BorderRadius.circular(10);

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: radius,
        color: app.appInfoHover,
        boxShadow: [
          BoxShadow(
            color: app.appInfoDark.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: radius,
              child: Image.asset(
                'assets/shapes/wave_pay.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Bayar',
              style: TextStyle(
                color: app.appTextSecond,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
