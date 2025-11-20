import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/background/custom_background.dart';
import '../../../widgets/card/custom_anoueve_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/details_controller.dart';

class DetailsEventPage extends GetView<DetailsController> {
  const DetailsEventPage({super.key});

  @override
  //Title
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
    final data =
        (Get.arguments as Map<String, dynamic>?) ?? <String, dynamic>{};
    return Scaffold(
      body: CustomDetailBackground(
        style: DetailBgStyle.event,
        child: Column(
          children: [
            SizedBox(
              height: headerH,
              child: ReusableHeaderMenu(
                headerH: headerH,
                topPad: topPad,
                title: 'Detail event',
                showBackButton: true,
                backgroundColor: Colors.transparent,
                showWave: false,
              ),
            ),

            // Konten card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: CustomAnoueveCard(
                  title: data['title'] ?? 'Tanpa Judul',
                  dateLabel: 'Rentang acara',
                  dateValue: data['dateTime'] ?? '-',
                  locationLabel: 'Lokasi',
                  locationValue: data['location'] ?? '-',
                  descriptionLabel: 'Deskripsi',
                  description: data['description'] ?? '-',
                  isEvent: true,
                  onSetReminder: controller.saveChanges,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
