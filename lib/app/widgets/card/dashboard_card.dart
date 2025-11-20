import 'package:flutter/material.dart';

import '../../core/constant/colors/colors.dart' as app;

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.backgroundImage,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ctaText,
    required this.rtText,
    required this.iconImage,
    super.key,
    this.onTap,
  });
  final String backgroundImage;
  final String title;
  final String subtitle;
  final String description;
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: app.appTextSecond,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        _buildDesc(description),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Icon + CTA
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Image besar di belakang
                        SizedBox(
                          width: 110,
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

                        // CTA text di atas image
                        Padding(
                          padding: EdgeInsets.zero, // beri sedikit jarak dari tepi image
                          child: Text(
                            ctaText,
                            style: TextStyle(
                              color: app.appTextSecond.withAlpha(200),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
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
  Widget _buildDesc(String subtitle) {
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
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: parts[1],
              style: const TextStyle(
                color: app.appTextSecond,
                fontWeight: FontWeight.w700,
                fontSize: 18,
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
          fontSize: 18,
        ),
      );
    }
  }
}

class _RtBadge extends StatelessWidget {
  const _RtBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      text,
      style: const TextStyle(
        color: app.appTextSecond,
        fontWeight: FontWeight.w500,
        fontSize: 10,
      ),
    ),
  );
}
