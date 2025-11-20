import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class ChargeItem {
  // e.g., "Iuran pkk"
  const ChargeItem({required this.amountText, required this.label});
  final String amountText; // e.g., "Rp.10.000"
  final String label;
}

class CustomDetailPaymentCard extends StatelessWidget {
  // e.g., "Harap segera bayar"

  const CustomDetailPaymentCard({
    required this.title,
    required this.year,
    required this.charges,
    required this.totalText,
    required this.statusText,
    required this.statusColor,
    super.key,
    this.statusHint = '',
  });
  final String title; // e.g., "Oktober" or "Lomba 17 Agustus"
  final String year; // e.g., "2025"
  final List<ChargeItem> charges;
  final String totalText; // e.g., "Rp.50.000"
  final String statusText; // e.g., "Belum lunas"
  final Color statusColor; // color of status badge
  final String statusHint;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: app.appBackgroundMain,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: app.appTextDark.withValues(alpha: 0.06),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        Positioned(
          right: -0,
          bottom: -30,
          child: Image.asset(
            'assets/shapes/neutral_card_big.png',
            width: 170,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          right: -25,
          top: -10,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              app.appTextDark.withValues(alpha: 0.10),
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/shapes/neutral_big.png',
              width: 170,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: 2,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              app.appTextDark.withValues(alpha: 0.3),
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/shapes/neutral2_big.png',
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title + Year
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: app.appTextDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    year,
                    style: const TextStyle(
                      color: app.appTextDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Breakdown label
              const Text(
                'Rincian biaya :',
                style: TextStyle(
                  color: app.appTextDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              // Charges list
              ...charges.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '- ${c.amountText}',
                        style: const TextStyle(
                          color: app.appSuccessMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          c.label,
                          style: const TextStyle(
                            color: app.appTextDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Row: Total & Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total biaya :',
                          style: TextStyle(
                            color: app.appTextDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalText,
                          style: const TextStyle(
                            color: app.appSuccessMain,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _StatusBadge(text: statusText, color: statusColor),
                      if (statusHint.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          statusHint,
                          style: TextStyle(
                            color: app.appTextDark.withValues(alpha: 0.35),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const double h = 28;
    const double w = 112;
    return Container(
      height: h,
      width: w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(h),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: app.appBackgroundMain,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
