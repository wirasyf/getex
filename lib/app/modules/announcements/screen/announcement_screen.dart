import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../core/helper/format_date.dart';
import '../../../core/helper/format_time.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/card/announcement_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_month.dart';
import '../controllers/announcement_controller.dart';

class AnnouncementView extends GetView<AnnouncementsController> {
  const AnnouncementView({super.key});

  @override
  // Header
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: app.appBackgroundForm,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Pengumuman',
              rightWidget: GestureDetector(
                onTap: () async {
                  final res = await CustomFilterMonth.show(
                    context,
                    initialYear: controller.selectedYear.value,
                    initialMonth: controller.selectedMonth.value,
                  );
                  if (res != null) {
                    unawaited(controller.setYear(res.year));
                    unawaited(controller.setMonth(res.month));
                  }
                },
                child: Image.asset(
                  'assets/icons/filter.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),

          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              // Konten di dalam container - YANG BERUBAH
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        app.appInfoHover,
                      ),
                    ),
                  );
                }

                final data = controller.announcements;

                // Empty state
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/ilustration/announcement_empty.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Tidak ada pengumuman',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }

                // List data
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return AnnouncementCard(
                      title: item.title,
                      date: DateFormatter.formatDate(item.startDate),
                      time: TimeFormatter.formatTime(item.time),
                      onTap: () {
                        Get.toNamed(
                          Routes.DETAILS_ANNOUNCEMENT,
                          arguments: item.id,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
