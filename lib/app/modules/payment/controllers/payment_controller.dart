import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/models/payment.dart';
import '../../details/screen/details_payment_history.dart';
import '../screen/detail_payment.dart';

// --- IMPORT DIUBAH ---
// Hapus import lama: import '../screen/payment_form.dart';
// Tambahkan 2 import baru ini:
import '../screen/monthly_payment_form.dart';
import '../screen/one_time_payment_form.dart';
// --- AKHIR IMPORT ---

enum PaymentStatus { belumLunas, proses, lunas }

enum PaymentTab { bulanan, sekaliBayar }

class PaymentItem {
  PaymentItem({
    required this.title,
    required this.description,
    required this.amount,
    required this.year,
    required this.status,
  });
  final String title;
  final String description;
  final String amount;
  final String year;
  final PaymentStatus status;

  // ignore: prefer_constructors_over_static_methods, prefer_expression_function_bodies
  static PaymentItem fromTransaction(Transaction transaction) {
    // Example mapping, adjust as needed for your Transaction model
    return PaymentItem(
      title: transaction.title,
      description: transaction.description,
      amount: transaction.amount,
      year: transaction.date.split('/').last, // Example: extract year from date
      status: _mapStatus(transaction.status),
    );
  }

  static PaymentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'berhasil':
        return PaymentStatus.lunas;
      case 'proses':
        return PaymentStatus.proses;
      default:
        return PaymentStatus.belumLunas;
    }
  }
}

class PaymentController extends GetxController {
  final selectedTab = PaymentTab.bulanan.obs;
  final payments = <PaymentItem>[].obs;
  final selectedMonth = 'September'.obs;
  final nominal = '50000'.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedPaymentItem = Rx<PaymentItem?>(null);

  // Loading states
  final isPaymentContentLoaded = false.obs;
  final isPaymentHistoryContentLoaded = false.obs;
  Timer? _paymentHistoryTimer;

  final TextEditingController nominalController = TextEditingController();

  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final RxList<Transaction> transactions = <Transaction>[
    Transaction(
      id: '1',
      title: 'Lomba 17 Agustus',
      description: 'Pembayaran sekali bayar',
      amount: 'Rp.100.000',
      date: '04/07/2025',
      status: 'Berhasil',
      createdAt: DateTime(2025, 7, 4),
    ),
    Transaction(
      id: '2',
      title: 'September',
      description: 'Pembayaran bulanan',
      amount: 'Rp.50.000',
      date: '04/07/2025',
      status: 'Berhasil',
      createdAt: DateTime(2025, 7, 4),
    ),
    Transaction(
      id: '3',
      title: 'Agustus',
      description: 'Pembayaran bulanan',
      amount: 'Rp.50.000',
      date: '04/07/2025',
      status: 'Berhasil',
      createdAt: DateTime(2025, 7, 4),
    ),
    Transaction(
      id: '4',
      title: 'Juli',
      description: 'Pembayaran bulanan',
      amount: 'Rp.50.000',
      date: '04/07/2025',
      status: 'Berhasil',
      createdAt: DateTime(2025, 7, 4),
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    nominalController.text = 'Rp. 50.000';
    _loadPayments();
  }

  @override
  void onClose() {
    _paymentHistoryTimer?.cancel();
    nominalController.dispose();
    super.onClose();
  }

  void startPaymentHistoryLoadingTimer() {
    if (!isPaymentHistoryContentLoaded.value) {
      _paymentHistoryTimer?.cancel();
      _paymentHistoryTimer = Timer(const Duration(seconds: 5), () {
        isPaymentHistoryContentLoaded.value = true;
      });
    }
  }

  void resetLoadingStates() {
    isPaymentContentLoaded.value = false;
    isPaymentHistoryContentLoaded.value = false;
  }

  void _loadPayments() {
    if (selectedTab.value == PaymentTab.bulanan) {
      payments.value = [
        PaymentItem(
          title: 'Oktober',
          description: 'Iuran kas bulanan',
          amount: 'Rp.50.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.belumLunas,
        ),
        PaymentItem(
          title: 'September',
          description: 'Iuran kas bulanan',
          amount: 'Rp.50.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.proses,
        ),
        PaymentItem(
          title: 'Agustus',
          description: 'Iuran kas bulanan',
          amount: 'Rp.50.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.lunas,
        ),
        PaymentItem(
          title: 'Juli',
          description: 'Iuran kas bulanan',
          amount: 'Rp.50.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.lunas,
        ),
        PaymentItem(
          title: 'Juni',
          description: 'Iuran kas bulanan',
          amount: 'Rp.50.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.lunas,
        ),
      ];
    } else {
      payments.value = [
        PaymentItem(
          title: 'Lomba 17 Agustus',
          description: 'Iuran kas dadakan',
          amount: 'Rp.100.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.belumLunas,
        ),
        PaymentItem(
          title: 'Lomba 17 Agustus',
          description: 'Iuran kas dadakan',
          amount: 'Rp.100.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.proses,
        ),
        PaymentItem(
          title: 'Lomba 17 Agustus',
          description: 'Iuran kas dadakan',
          amount: 'Rp.100.000',
          year: selectedYear.value.toString(),
          status: PaymentStatus.lunas,
        ),
      ];
    }
  }

  void switchTab(PaymentTab tab) {
    selectedTab.value = tab;
    _loadPayments();
  }

  void setYear(int year) {
    selectedYear.value = year;
    _loadPayments();
  }

  // Submit transaksi
  void submitTransaction() {
    if (nominalController.text.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Nominal tidak boleh kosong',
        backgroundColor: app.appErrorMain,
        colorText: app.appTextSecond,
      );
      return;
    }

    Get.snackbar(
      'Sukses',
      'Transaksi ${selectedMonth.value} berhasil diproses',
      backgroundColor: app.appSuccessMain,
      colorText: app.appTextSecond,
      duration: const Duration(seconds: 2),
    );

    nominalController.clear();
    selectedMonth.value = 'September';
  }

  void onPaymentTap(PaymentItem item) {
    selectedPaymentItem.value = item;
    Get.to(() => DetailPaymentView(item: item));
  }

  void onPaymentHistoryTap(PaymentItem item) {
    selectedPaymentItem.value = item;
    Get.to(DetailPaymentHistoryScreen.new);
  }

  // --- FUNGSI INI DIPERBARUI ---
  void onPayButtonPressed() {
    PaymentItem? target;
    // Cari item pertama yang belum lunas
    for (final p in payments) {
      if (p.status == PaymentStatus.belumLunas) {
        target = p;
        break;
      }
    }
    // Jika semua sudah lunas/proses, fallback ke item pertama
    target ??= payments.isNotEmpty ? payments.first : null;

    // Jika list kosong, jangan lakukan apa-apa
    if (target == null) {
      Get.snackbar(
        'Info',
        'Tidak ada tagihan yang tersedia.',
        backgroundColor: app.appInfoHover,
        colorText: app.appTextSecond,
      );
      return;
    }

    // --- LOGIKA UTAMA ---
    // Cek tab yang sedang aktif
    if (selectedTab.value == PaymentTab.bulanan) {
      // Arahkan ke form bulanan
      Get.to(() => MonthlyPaymentFormView(targetItem: target));
    } else {
      // Arahkan ke form sekali bayar
      Get.to(() => OneTimePaymentFormView(targetItem: target));
    }
    // --- AKHIR PERUBAHAN ---
  }

  // Format nominal
  String formatNominal(String nominal) =>
      nominal.isEmpty ? 'Rp. 0' : 'Rp. $nominal';

  List<Transaction> getTransactionsByStatus(String status) =>
      transactions.where((t) => t.status == status).toList();
}
