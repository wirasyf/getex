import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart';
import '../../../core/helper/format_date.dart';
import '../../../widgets/background/custom_background.dart';
import '../../../widgets/card/custom_anoueve_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../controllers/event_detail_controller.dart';

class DetailsEventPage extends GetView<EventDetailController> {
  const DetailsEventPage({super.key});

  @override
  //Title
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTextLight,
                      ),
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
                    title: detail.eventName,
                    dateLabel: 'Rentang acara',
                    dateValue:'${DateFormatter.formatDate(detail.startDate)} - ${DateFormatter.formatDate(detail.endDate)}',
                    locationLabel: 'Lokasi',
                    locationValue: detail.location ?? '-',
                    descriptionLabel: 'Deskripsi',
                    description: detail.description,
                    isEvent: true,
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
