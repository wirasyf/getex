import 'package:flutter/material.dart';
import 'dashboard_card.dart';
/* RT Badge */


//---

class AlertCard extends StatelessWidget {
  const AlertCard({
    required this.title,
    required this.subtitle,
    super.key,
    this.rtText = 'RT 10',
    this.onTap,
  });
  final String title;
  final String subtitle;
  final String rtText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DashboardCard(
    backgroundImage: 'assets/bg/bg_alert.png',
    title: title,
    subtitle: subtitle,
    ctaText: 'Klik untuk selengkapnya',
    rtText: rtText,
    iconImage: 'assets/ilustration/warning.png',
    onTap: onTap, description: '',
  );
}
