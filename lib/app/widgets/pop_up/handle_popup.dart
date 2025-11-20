import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/constant/colors/colors.dart' as app;

class HandledPopup extends StatelessWidget {
  final String nameText;
  final String dateText;
  final ImageProvider? imagePath;
  final String descText;

  const HandledPopup({
    super.key,
    required this.nameText,
    required this.dateText,
    required this.imagePath,
    required this.descText,
  });

  @override
  Widget build(BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        backgroundColor: app.appTextSecond,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/image/krt.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nameText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: app.appTextDark,
                          ),
                        ),
                        Text(
                          dateText,
                          style: const TextStyle(
                            color: app.appTextDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: app.appNeutralLight,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: app.appTextDark,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),

              // ================= JUDUL =================
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Judul',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: app.appTextDark,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '18:00 WIB',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: app.appTextDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildBox(nameText),

              // ================= FOTO =================
              const SizedBox(height: 16),
              const Text(
                'Foto Bukti Balasan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: app.appTextDark,
                ),
              ),
              const SizedBox(height: 8),

               ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: imagePath != null
                              ? Image(
                                  image: imagePath!,
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

              // ================= DESKRIPSI =================
              const SizedBox(height: 10),
              const Text(
                'Deskripsi Balasan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: app.appTextDark,
                ),
              ),
              const SizedBox(height: 8),
              _buildBox(descText),
            ],
          ),
        ),
      ),
    );
}

// Box reusable
Widget _buildBox(String text) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: app.appNeutralLight,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(color: app.appTextDark),
    ),
  );
}

// Image loader
class _SmartImage extends StatelessWidget {
  final String path;
  const _SmartImage({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) {
      return Image.asset(
        'assets/image/selokan.png',
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      path,
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/image/selokan.png',
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
      ),
    );
  }
}
