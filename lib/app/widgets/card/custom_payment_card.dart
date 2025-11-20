import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

enum PaymentStatus { unpaid, paid, pending }

class CustomPaymentCard extends StatelessWidget {
  // hide lower connector

  const CustomPaymentCard({
    required this.month,
    required this.year,
    required this.amount,
    super.key,
    this.subtitle = 'Iuran kas bulanan',
    this.status = PaymentStatus.unpaid,
    this.onTap,
    this.showTimeline = true,
    this.isFirst = false,
    this.isLast = false,
  });
  final String month; // e.g., "Oktober"
  final String year; // e.g., "2025"
  final String amount; // e.g., "Rp.50.000"
  final String subtitle; // e.g., "Iuran kas bulanan"
  final PaymentStatus status;
  final VoidCallback? onTap;
  // Timeline options
  final bool showTimeline;
  final bool isFirst; // hide upper connector
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _statusColor(status);
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _TimelineRail(isFirst: isFirst, isLast: isLast),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
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
                      // Background shapes layered per mockup
                      Positioned(
                        right: -12,
                        bottom: 0,
                        child: Image.asset(
                          'assets/shapes/cardneutral.png',
                          width: 180,
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
                            'assets/shapes/neutral.png',
                            width: 160,
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
                            'assets/shapes/neutral2.png',
                            width: 190,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Top row: title (right-aligned) + year
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    month,
                                    textAlign: TextAlign.left,
                                    textWidthBasis: TextWidthBasis.parent,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: app.appTextDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    year,
                                    style: const TextStyle(
                                      color: app.appTextDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Bottom row: subtitle + amount | status + link
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subtitle,
                                        style: const TextStyle(
                                          color: app.appTextKet,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        amount,
                                        style: TextStyle(
                                          color: _statusColor(status),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _StatusBadge(
                                      text: _statusText(status),
                                      color: badgeColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Klik untuk selengkapnya',
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        // ignore: deprecated_member_use
                                        color: app.appTextDark.withOpacity(
                                          0.35,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return app.appSuccessMain;
      case PaymentStatus.pending:
        return app.appPendingMain;
      case PaymentStatus.unpaid:
        return app.appErrorMain;
    }
  }

  static String _statusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'Lunas';
      case PaymentStatus.pending:
        return 'Proses';
      case PaymentStatus.unpaid:
        return 'Belum lunas';
    }
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({this.isFirst = false, this.isLast = false});
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 20,
    child: Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 2,
              color: isFirst
                  ? app.appBackgroundMain.withValues(alpha: 0)
                  : app.appNeutralLight,
            ),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isFirst ? app.appInfoDark : app.appNeutralMain,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 2,
              color: isLast
                  ? app.appBackgroundMain.withValues(alpha: 0)
                  : app.appNeutralLight,
            ),
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
