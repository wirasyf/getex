import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../controllers/report_controller.dart';
import 'report_edit.dart';

class ReportDetailView extends StatelessWidget {
  const ReportDetailView({
    required this.index,
    required this.name,
    required this.date,
    required this.image,
    required this.description,
    required this.handled,
    super.key, 
    required  this.title,
  });

  final int index;
  final String title;
  final String name;
  final String date;
  final String image;
  final String description;
  final bool handled;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: 'Detail Pengaduan',
            ),
          ),

          // Body
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Obx(() {
                  final ctrl = Get.find<ReportController>();
                  if (index < 0 || index >= ctrl.reports.length) {
                    return const Center(
                      child: Text(
                        'Data tidak ditemukan',
                        style: TextStyle(color: app.appTextDark),
                      ),
                    );
                  }

                  final item = ctrl.reports[index];
                  final desc = item.description.isNotEmpty
                      ? item.description
                      : description;
                  final titleText = item.title.isNotEmpty
                      ? item.title
                      : 'Judul Pengaduan';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header user
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: app.appPrimaryLight,
                                  child: Icon(
                                    Icons.person,
                                    color: app.appPrimaryMain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: app.appTextDark,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: const TextStyle(
                                          color: app.appTextKet,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Icon handled
                                GestureDetector(
                                  onTap: handled
                                      ? () => _showHandledPopup(
                                          context,
                                          name,
                                          date,
                                          image,
                                          desc,
                                        )
                                      : null,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: app.appInfoLight,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Image.asset(
                                          'assets/icons/message.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                      if (handled)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: app.appErrorMain,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: app.appBackgroundMain,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Judul Pengaduan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: app.appTextDark,
                                  ),
                                ),
                                Text(
                                  '18:00 WIB',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: app.appTextDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildBox(titleText),
                            const SizedBox(height: 16),

                            const Text(
                              'Foto Bukti Pengaduan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: app.appTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _SmartImage(path: image),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Deskripsi Pengaduan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: app.appTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildBox(desc),
                            const SizedBox(height: 16),

                            // Status
                            Align(
                              alignment: Alignment.centerRight,
                              child: handled
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: app.appSuccessMain,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Sudah ditangani',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: app.appTextSecond,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: app.appPendingMain,
                                            foregroundColor: app.appTextSecond,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                            minimumSize: const Size(0, 44),
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final cur = ctrl.reports[index];
                                            await Get.to(
                                              () => ReportEditView(
                                                index: index,
                                                initialTitle: cur.title,
                                                initialDate: cur.date,
                                                initialDescription:
                                                    cur.description,
                                                initialImageUrl: cur.imageUrl,
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 16,
                                          ),
                                          label: const Text('Edit'),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: app.appNeutralHover,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            'Belum ditangani',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: app.appTextSecond,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String text) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: app.appBackgroundMain,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: app.appNeutralLight),
    ),
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: const TextStyle(
        color: app.appTextDark,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    ),
  );

  void _showHandledPopup(
    BuildContext context,
    String nameText,
    String dateText,
    String imagePath,
    String descText,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: app.appTextDark.withValues(alpha: 0.54),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: app.appPrimaryLight,
                    child: Icon(Icons.person, color: app.appPrimaryMain),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: app.appTextDark,
                          ),
                        ),
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
                child: _SmartImage(path: imagePath),
              ),
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
}

// Widget gambar aman
class _SmartImage extends StatelessWidget {
  const _SmartImage({required this.path});
  final String path;

  bool get _isNetwork => path.startsWith('http');
  bool get _isFile => !kIsWeb && (path.startsWith('/') || path.contains(r'\'));

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return Image.network(
        path,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else if (_isFile) {
      return Image.file(
        File(path),
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    } else {
      return _fallback();
    }
  }

  Widget _fallback() => Image.asset(
    'assets/image/selokan.png',
    height: 180,
    width: double.infinity,
    fit: BoxFit.cover,
  );
}
