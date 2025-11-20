import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../core/helper/format_date.dart';
import '../../../core/helper/load_image.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/handle_popup.dart';
import '../controllers/report_controller.dart';
import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  const ReportDetailView({super.key});

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

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: app.appTextDark),
                    ),
                  );
                }

                final item = controller.complaintDetail.value!;
                print('=== DEBUG START ===');
                print('item: $item');
                print('item.user: ${item.user}');
                print('item.user.name: ${item.user.name}');
                print('item.user.photo: ${item.user.photo}');
                print('item.period: ${item.period}');
                print('item.title: ${item.title}');
                print('item.description: ${item.description}');
                print('item.image: ${item.image}');
                print('item.status: ${item.status}');
                print('item.repliedAt: ${item.repliedAt}');
                print('item.reply: ${item.reply}');
                print('item.replyImage: ${item.replyImage}');
                print('=== DEBUG END ===');
                final userName = item.user.name;
                final userProfilePhoto = loadLaravelImage(item.user.photo);

                final date = DateFormatter.formatDateLong(item.period);
                final title = item.title.isNotEmpty
                    ? item.title
                    : 'Judul Pengaduan';
                final description = item.description.isNotEmpty
                    ? item.description
                    : 'Tidak ada deskripsi';
                final image = loadPrivateLaravelImage(item.image ?? '');
                //
                final handled = item.status == "finished";
                final repliedAt = item.repliedAt != null
                    ? DateFormatter.formatDateLong(item.repliedAt)
                    : 'Belum dibalas';
                final replyText = item.reply ?? 'Belum ada balasan';
                final replyImage = item.replyImage != null
                    ? loadLaravelImage(item.replyImage)
                    : null;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: SingleChildScrollView(
                    child: Column(
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
                                          userName,
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
                                  // Icon status
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: item.status == "finished"
                                          ? () => showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel: 'HandledPopup',
                                              pageBuilder: (context, a, b) =>
                                                  HandledPopup(
                                                    nameText: item.title,
                                                    dateText:
                                                        DateFormatter.formatDateLong(
                                                          item.period,
                                                        ),
                                                    imagePath: loadLaravelImage(
                                                      item.replyImage,
                                                    ),
                                                    descText:
                                                        item.reply ??
                                                        'Tidak ada balasan',
                                                  ),
                                            )
                                          : null,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          // ICON UTAMA
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: app.appInfoLight,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow:
                                                  item.status == "finished"
                                                  ? [
                                                      BoxShadow(
                                                        color: const Color(
                                                          0xFF0DA6D6,
                                                        ).withOpacity(0.20),
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                        blurRadius: 30,
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            child: Image.asset(
                                              'assets/icons/message.png',
                                              width: 20,
                                              height: 20,
                                              color: item.status == "finished"
                                                  ? null
                                                  : Colors.grey,
                                            ),
                                          ),

                                          // 🔴 BADGE TITIK MERAH
                                          if (item.status == "finished")
                                            Positioned(
                                              top: -2,
                                              right: -2,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              _buildBox(title),
                              const SizedBox(height: 16),

                              const Text(
                                'Foto Bukti Pengaduan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: app.appTextDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FutureBuilder<Image>(
                                future: image, // panggil helper async
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      height: 180,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              app.appInfoHover,
                                            ),
                                      ),
                                    );
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/image/selokan.png',
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: snapshot.data,
                                    );
                                  }
                                },
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
                              _buildBox(description),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                              backgroundColor:
                                                  app.appPendingMain,
                                              foregroundColor:
                                                  app.appTextSecond,
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              // final cur = ctrl.reports[index];
                                              // await Get.to(
                                              //   () => ReportEditView(
                                              //     index: index,
                                              //     initialTitle: cur.title,
                                              //     initialDate: cur.date,
                                              //     initialDescription:
                                              //         cur.description,
                                              //     initialImageUrl: cur.imageUrl,
                                              //   ),
                                              // );
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                    ),
                  ),
                );
              }),
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
}
