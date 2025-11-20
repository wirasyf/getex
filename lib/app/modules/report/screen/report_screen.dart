import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../core/helper/format_date.dart';
import '../../../core/helper/load_image.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/button/add_button.dart';
import '../../../widgets/card/custom_report_card.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_month.dart';
import '../controllers/report_controller.dart';

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
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
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
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: app.appPrimaryMain,
                      ),
                    );
                  }

                  final items = controller.complaints;

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

                  return RefreshIndicator(
                    color: app.appInfoHover,
                    onRefresh: () async {
                      await controller
                          .fetchComplaints(); // atau nama fungsi load data kamu
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final complaint = items[index];

                        // Tentukan status
                        final isHandled = complaint.status == 'finished';
                        print(complaint.status);

                        return CustomPengaduanCard(
                          title: complaint.title,
                          name: complaint.user.name,
                          dateText: DateFormatter.formatDateLong(complaint.period),
                          message: complaint.description,
                          status: isHandled
                              ? PengaduanStatus.handled
                              : PengaduanStatus.unhandled,

                          avatarImage: loadLaravelImage(complaint.user.photo),
                          thumbnail: loadLaravelImage(complaint.image),
                          onTap: () {
                            Get.toNamed(
                              Routes.REPORT_DETAIL,
                              arguments: {'complaintId': complaint.id},
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // Add button
          Positioned(
            right: 20,
            bottom: 30,
            child: AddReportButton(
              onTap: () => Get.toNamed(Routes.REPORT_FORM),
            ),
          ),
        ],
      ),
    );
  }
}
