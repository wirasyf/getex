import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/add_button.dart';
import '../../../widgets/card/custom_report_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_month.dart';
import '../controllers/report_controller.dart';
import 'report_detail.dart';
import 'report_form.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.32;
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
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Pengaduan',
              showBackButton: false,
              rightWidget: GestureDetector(
                onTap: () async {
                  // Filter bulan
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

          // Panel konten
          Positioned(
            top: headerH * 0.65,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Obx(() {
                final items = controller.reports;
                if (items.isEmpty) {
                  // State kosong
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 180,
                            child: Image.asset(
                              'assets/ilustration/pos.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.inbox_outlined,
                                size: 120,
                                color: app.appNeutralMain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada pengaduan!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: app.appTextKet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    ImageProvider? thumbnailProvider; // Resolve thumbnail
                    if (item.imageUrl != null) {
                      final url = item.imageUrl!;
                      if (url.startsWith('http://') ||
                          url.startsWith('https://') ||
                          url.startsWith('blob:')) {
                        thumbnailProvider = NetworkImage(url);
                      } else if (url.startsWith('/') || url.contains(r'\')) {
                        thumbnailProvider = kIsWeb
                            ? NetworkImage(url)
                            : FileImage(File(url));
                      }
                    }

                    return CustomPengaduanCard(
                      title: item.title,
                      name: item.name,
                      dateText: item.date,
                      message: item.description,
                      status: item.handled
                          ? PengaduanStatus.handled
                          : PengaduanStatus.unhandled,
                      thumbnail: thumbnailProvider,
                      avatarImage: null,
                      onTap: () {
                        // Ke halaman detail
                        Get.to(
                          () => ReportDetailView(
                            index: index,
                            title: item.title,
                            name: item.name,
                            date: item.date,
                            image:
                                item.imageUrl ??
                                'https://i.imgur.com/BoN9kdC.png',
                            description: item.description,
                            handled: item.handled,
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),

          // Add button
          Positioned(
            right: 20,
            bottom: 30,
            child: AddReportButton(
              onTap: () => Get.to(() => const ReportFormView()),
            ),
          ),
        ],
      ),
    );
  }
}
