import 'package:flutter/material.dart';

import 'dashboard_card.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.eventName,
    required this.description,
    required this.eventDate,
    required this.rtText,
    super.key,
    this.onTap,
  });
  final String eventName;
  final String description;
  final String eventDate;
  final String rtText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DashboardCard(
    backgroundImage: 'assets/bg/bg_event.png',
    title: eventName,
    subtitle: 'Rentan acara',
    description: eventDate,
    ctaText: 'Klik untuk selengkapnya',
    rtText: rtText,
    iconImage: 'assets/ilustration/event.png',
    onTap: onTap,
  );
}
