import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

enum PengaduanStatus { handled, unhandled }

class CustomPengaduanCard extends StatelessWidget {
  const CustomPengaduanCard({
    required this.title,
    required this.name,
    required this.dateText,
    required this.message,
    super.key,
    this.status = PengaduanStatus.unhandled,
    this.thumbnail,
    this.avatarImage,
    this.onTap,
  });
  final String name;
  final String title; // judul pengaduan
  final String dateText;
  final String message; // deskripsi pengaduan
  final PengaduanStatus status;
  final ImageProvider? thumbnail;
  final ImageProvider? avatarImage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _statusColor(status);

    precacheImage(const AssetImage('assets/image/selokan.png'), context);
    precacheImage(const AssetImage('assets/image/krt.png'), context);
    precacheImage(const AssetImage('assets/shapes/wave3.png'), context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: app.appBackgroundMain,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: app.appTextMain.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: LayoutBuilder(
                  builder: (context, constraints) => Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/shapes/wave3.png',
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Header: avatar, name, date
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: app.appSecondaryLight,
                        backgroundImage: avatarImage,
                        child: avatarImage == null
                            ? ClipOval(
                                child: Image.asset(
                                  'assets/image/krt.png',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48,
                                    height: 48,
                                    color: app.appSecondaryLight,
                                    child: const Icon(
                                      Icons.person,
                                      color: app.appTextSecond,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: app.appTextDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateText,
                              style: const TextStyle(
                                color: app.appTextKet,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Body: thumbnail + title + message + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: app.appTextMain.withValues(alpha: 0.05),
                          width: 72,
                          height: 72,
                          child: thumbnail != null
                              ? Image(
                                  image: thumbnail!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    'assets/image/selokan.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/image/selokan.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title,
                              style: const TextStyle(
                                color: app.appTextDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Text(
                              message,
                              style: const TextStyle(
                                color: app.appTextKet,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _StatusBadge(
                                text: _statusText(status),
                                color: badgeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Klik untuk selengkapnya',
                      style: TextStyle(
                        color: app.appTextMain.withValues(alpha: 0.35),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(PengaduanStatus status) {
    switch (status) {
      case PengaduanStatus.handled:
        return app.appSuccessMain;
      case PengaduanStatus.unhandled:
        return app.appNeutralHover;
    }
  }

  static String _statusText(PengaduanStatus status) {
    switch (status) {
      case PengaduanStatus.handled:
        return 'Sudah ditangani';
      case PengaduanStatus.unhandled:
        return 'Belum ditangani';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: app.appTextSecond,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
