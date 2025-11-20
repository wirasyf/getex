import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.backgroundImage,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.rtText,
    required this.iconImage,
    super.key,
    this.onTap,
  });
  final String backgroundImage;
  final String title;
  final String subtitle;
  final String ctaText;
  final String rtText;
  final String iconImage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Konten utama
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Teks kiri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: app.appTextSecond,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSubtitle(subtitle),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Icon + CTA
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          iconImage,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: app.appTextSecond,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ctaText,
                        style: TextStyle(
                          color: app.appTextSecond.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // RT Badge di kanan atas
            Positioned(top: 12, right: 12, child: _RtBadge(text: rtText)),
          ],
        ),
      ),
    ),
  );

  // Helper method untuk membuat subtitle dengan 2 ukuran font
  Widget _buildSubtitle(String subtitle) {
    // Split subtitle berdasarkan newline
    final parts = subtitle.split('\n');

    if (parts.length >= 2) {
      // Jika ada 2 baris: baris pertama kecil, baris kedua besar
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${parts[0]}\n',
              style: const TextStyle(
                color: app.appTextSecond,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            TextSpan(
              text: parts[1],
              style: const TextStyle(
                color: app.appTextSecond,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    } else {
      // Jika hanya 1 baris, tampilkan normal
      return Text(
        subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: app.appTextSecond,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      );
    }
  }
}

//---

/* RT Badge */
class _RtBadge extends StatelessWidget {
  const _RtBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: app.appTextSecond.withValues(alpha: 0.28),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: app.appTextSecond,
        fontWeight: FontWeight.w700,
        fontSize: 10,
      ),
    ),
  );
}

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
    onTap: onTap,
  );
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
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
    backgroundImage: 'assets/bg/bg_announcement.png',
    title: title,
    subtitle: subtitle,
    ctaText: 'Klik untuk selengkapnya',
    rtText: rtText,
    iconImage: 'assets/ilustration/announcement.png',
    onTap: onTap,
  );
}

class EventCard extends StatelessWidget {
  const EventCard({
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
    backgroundImage: 'assets/bg/bg_event.png',
    title: title,
    subtitle: subtitle,
    ctaText: 'Klik untuk selengkapnya',
    rtText: rtText,
    iconImage: 'assets/ilustration/event.png',
    onTap: onTap,
  );
}
