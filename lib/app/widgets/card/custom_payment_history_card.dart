import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;
import '../../data/models/payment.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({required this.transaction, super.key});
  final Transaction transaction;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: app.appBackgroundMain,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: app.appTextMain.withValues(alpha: 0.06),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan tanggal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: app.appTextDark,
              ),
            ),
            Text(
              transaction.date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: app.appTextKet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Deskripsi
        Text(
          transaction.description,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: app.appTextDark,
          ),
        ),
        const SizedBox(height: 12),

        // Jumlah dan status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transaction.amount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: app.appPrimaryMain,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: transaction.status.toLowerCase() == 'success'
                    ? app.appErrorMain
                    : app.appSuccessMain,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                transaction.status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: app.appTextSecond,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
