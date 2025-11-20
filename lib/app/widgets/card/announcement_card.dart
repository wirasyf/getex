import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    required this.title,
    required this.time,
    required this.date,
    super.key,
    this.rtText = 'RT 10',
    this.onTap,
  });
  final String title;
  final String time;
  final String rtText;
  final VoidCallback? onTap;
  final String date;

  @override
  Widget build(BuildContext context) => DashboardCard(
    backgroundImage: 'assets/bg/bg_announcement.png',
    title: title,
    subtitle: date,
    description: time,
    ctaText: 'Klik untuk selengkapnya',
    rtText: rtText,
    iconImage: 'assets/ilustration/announcement.png',
    onTap: onTap,
  );
}
