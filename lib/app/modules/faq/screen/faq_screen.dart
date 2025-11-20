import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../controllers/faq_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final FaqController controller = Get.put(FaqController());

  // 1. Inisialisasi ScrollController
  final ScrollController _scrollController = ScrollController();

  // 2. Map untuk menyimpan GlobalKey untuk setiap ExpansionTile
  // Ini diperlukan agar kita bisa mendapatkan posisi RenderBox untuk scroll.
  final Map<int, GlobalKey> _tileKeys = {};

  final List<Map<String, String>> faqData = [
    {
      'title': '1. Apa itu aplikasi SMART RT?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': '2. Apakah data pribadi saya aman?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': '3. Bagaimana cara melaporkan masalah?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': '4. Bagaimana cara membayar bulanan?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': '5. Bagaimana cara membayar iuran?',
      'content':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
  ];

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
              title: 'FaQ',
            ),
          ),

          // Konten utama
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF6F7F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                // Pasang ScrollController
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  children: faqData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    // 3. Buat atau dapatkan GlobalKey unik untuk item ini
                    _tileKeys[index] = GlobalKey();
                    final GlobalKey expansionTileKey = _tileKeys[index]!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Obx(
                        () => Container(
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
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              // Pasang GlobalKey
                              key: expansionTileKey,
                              initiallyExpanded: controller.isExpanded(index),
                              onExpansionChanged: (expanded) {
                                controller.toggleExpansion(
                                  expanded ? index : -1,
                                );

                                // 4. Logika Scroll-to-Top
                                if (expanded) {
                                  // Delay agar animasi ekspansi selesai dan RenderBox terhitung
                                  Future.delayed(
                                    const Duration(milliseconds: 300),
                                  ).then((_) {
                                    final RenderBox? renderBox =
                                        expansionTileKey.currentContext
                                                ?.findRenderObject()
                                            as RenderBox?;

                                    if (renderBox != null) {
                                      // Posisi Y absolut dari tile di layar
                                      final double yPosition = renderBox
                                          .localToGlobal(Offset.zero)
                                          .dy;

                                      // Hitung offset scroll yang diperlukan.
                                      // Kurangi yPosition dengan posisi awal konten scrollable (headerH * 0.70)
                                      // dan sedikit padding (10) agar tidak terlalu mepet.
                                      final double scrollOffset =
                                          _scrollController.offset +
                                          yPosition -
                                          (headerH * 0.70) -
                                          10;

                                      _scrollController.animateTo(
                                        scrollOffset,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  });
                                }
                              },
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              childrenPadding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              title: Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: app.appTextDark,
                                ),
                              ),
                              trailing: Icon(
                                controller.isExpanded(index)
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: app.appTextKet,
                              ),
                              children: [
                                Text(
                                  item['content']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: app.appTextDark,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
