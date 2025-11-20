import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart';
import '../../../core/helper/format_date.dart';
import '../../../core/helper/format_time.dart';
import '../../../widgets/background/custom_background.dart';
import '../../../widgets/card/custom_anoueve_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/announcement_detail_controller.dart';

class DetailsAnnouncementPage extends GetView<AnnouncementDetailController> {
  const DetailsAnnouncementPage({super.key});

  @override
  //Title
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CustomDetailBackground(
        style: DetailBgStyle.announcement,
        child: Column(
          children: [
            SizedBox(
              height: headerH,
              child: ReusableHeaderMenu(
                headerH: headerH,
                topPad: topPad,
                title: 'Detail pengumuman',
                showBackButton: true,
                backgroundColor: Colors.transparent,
                showWave: false,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTextLight,
                      ), // contoh warna
                    ),
                  );
                }

                final detail = controller.detail.value;

                if (detail == null) {
                  return const Center(child: Text('Data tidak ditemukan'));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: CustomAnoueveCard(
                    title: detail.title,
                    dateLabel: ' Tanggal & Waktu',
                    dateValue: '${DateFormatter.formatDate(detail.startDate)} - ${TimeFormatter.formatTime(detail.time)}',
                    locationLabel: 'Lokasi',
                    locationValue: detail.category?.name ?? '-',
                    descriptionLabel: 'Deskripsi',
                    description: detail.content,
                    onSetReminder: controller.saveChanges,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
