import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../core/helper/format_date.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/card/event_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_month.dart';
import '../controllers/event_controller.dart';

class EventView extends GetView<EventsController> {
  const EventView({super.key});

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
              title: 'Event',
              rightWidget: GestureDetector(
                onTap: () async {
                  final res = await CustomFilterMonth.show(
                    context,
                    initialYear: controller.selectedYear.value,
                    initialMonth: controller.selectedMonth.value,
                  );
                  if (res != null) {
                    controller
                      ..setYear(res.year)
                      ..setMonth(res.month);
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

          /// Konten utama
          Positioned(
            top: headerH * 0.7,
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        app.appInfoHover,
                      ),
                    ),
                  );
                }
                final data = controller.events;

                // Tampilan konten kalau kosong
                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/ilustration/event_empty.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Tidak ada event',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Anda akan melihat event di sini ketika ada kegiatan baru yang dijadwalkan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Konten
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return EventCard(
                      eventName: item.eventName,
                      eventDate: DateFormatter.formatRange(
                        item.startDate,
                        item.endDate,
                      ),
                      onTap: () {  Get.toNamed(
                          Routes.DETAILS_EVENT,
                          arguments: item.id,
                        );
                      },
                      description: item.description,
                      rtText: '10',
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
