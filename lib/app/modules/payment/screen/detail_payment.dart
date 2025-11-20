import 'package:flutter/material.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/card/custom_detail_payment_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/payment_controller.dart';

class DetailPaymentView extends StatelessWidget {
  const DetailPaymentView({required this.item, super.key});
  final PaymentItem item;

  // Status colors
  Color _statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.lunas:
        return app.appSuccessMain;
      case PaymentStatus.proses:
        return app.appPendingMain;
      case PaymentStatus.belumLunas:
        return app.appErrorMain;
    }
  }

  // Tentukan judul berdasarkan tipe
  String _getPaymentTypeTitle(PaymentItem item) {
    if (item.description.toLowerCase().contains('bulanan')) {
      return 'Detail bulanan';
    } else if (item.description.toLowerCase().contains('dadakan') ||
        item.title.toLowerCase().contains('lomba')) {
      return 'Detail sekali bayar';
    }
    return 'Detail pembayaran';
  }

  // Text status
  String _statusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.lunas:
        return 'Lunas';
      case PaymentStatus.proses:
        return 'Proses';
      case PaymentStatus.belumLunas:
        return 'Belum lunas';
    }
  }

  // List rincian biaya
  List<ChargeItem> _chargesForItem(PaymentItem i) {
    // Match the provided mockups
    if (i.title.toLowerCase().contains('lomba')) {
      return const [
        ChargeItem(amountText: 'Rp.20.000', label: 'Dekorasi'),
        ChargeItem(amountText: 'Rp.30.000', label: 'Beli hadiah'),
        ChargeItem(amountText: 'Rp.50.000', label: 'Sewa panggung'),
      ];
    }
    return const [
      ChargeItem(amountText: 'Rp.10.000', label: 'Iuran pkk'),
      ChargeItem(amountText: 'Rp.10.000', label: 'Iuran sampah'),
      ChargeItem(amountText: 'Rp.30.000', label: 'Iuran pos satpam'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
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
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: _getPaymentTypeTitle(item),
            ),
          ),

          // Content panel
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6F7F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              child: SingleChildScrollView(
                child: CustomDetailPaymentCard(
                  title: item.title,
                  year: item.year,
                  charges: _chargesForItem(item),
                  totalText: item.amount,
                  statusText: _statusText(item.status),
                  statusColor: _statusColor(item.status),
                  statusHint: item.status == PaymentStatus.belumLunas
                      ? 'Harap segera bayar'
                      : '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
