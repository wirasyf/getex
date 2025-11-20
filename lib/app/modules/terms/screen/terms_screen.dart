import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../controllers/terms_controller.dart';

class TermsScreen extends StatelessWidget {
  TermsScreen({super.key});
  final TermsController controller = Get.put(TermsController());

  // 1. Tambahkan ScrollController
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> termsData = [
    {
      'title': '1. Penerimaan syarat',
      'content':
          'Dengan mengakses dan menggunakan Smart RT,\npengguna setuju untuk mematuhi seluruh ketentuann \nyang berlaku. Jika Anda tidak menyetujui salah satu \nbagian dari ketentuan ini, mohon untuk tidak menggunakan aplikasi.',
    },
    {
      'title': '2. Penggunaan aplikasi',
      'content':
          'Smart RT ditujukan untuk mempermudah pengelolaan data warga di lingkungan RT, termasuk fitur-fitur berikut: \n\n   • Anggota Keluarga: Menyimpan dan memperbarui data \n      setiap anggota rumah tangga. \n   • Pengumuman: Melihat informasi terbaru dari pengurus \n      RT. \n   • Event: Mengetahui dan berpartisipasi dalam kegiatan \n      warga. \n   • Riwayat Transaksi: Melihat catatan keuangan pribadi \n      dan RT. \n   • Laporan Dana: Transparansi laporan keuangan kas RT. \n   • Pembayaran Iuran: Melakukan iuran bulanan atau \n     sekali bayar dengan mudah. \n   • Pengaduan: Menyampaikan masalah atau saran \n     langsung kepada pengurus RT, serta menerima balasan \n     dari pihak RT. \n\nPengguna wajib menjaga kerahasiaan akun dan bertanggung jawab atas semua aktivitas yang dilakukan menggunakan akunnya.',
    },
    {
      'title': '3. Data & privasi',
      'content':
          'Smart RT menghormati privasi pengguna. Data yang \ndikumpulkan hanya digunakan untuk keperluan administrasi ndan pengelolaan RT. Aplikasi ini tidak membagikan data pribadi pengguna kepada pihak ketiga tanpa izin.',
    },
    {
      'title': '4. Transaksi & pembayaran',
      'content':
          'Semua transaksi dalam aplikasi dilakukan secara aman. \nPengguna diharapkan memeriksa kembali nominal sebelum melakukan pembayaran. Kesalahan transaksi yang disebabkan oleh pengguna bukan tanggung jawab pihak pengelola aplikasi.',
    },
    {
      'title': '5. Pengumuman, event & pengaduan',
      'content':
          'Informasi yang disampaikan melalui fitur pengumuman dan event bersifat resmi dari pengurus RT. Setiap pengaduan akan ditindaklanjuti sesuai kebijakan pengurus, dan pengguna akan menerima balasan melalui sistem aplikasi.',
    },
    {
      'title': '6. Perubahan syarat & ketentuan',
      'content':
          'Pihak pengembang berhak memperbarui syarat dan ketentuan kapan saja. Perubahan akan diumumkan melalui aplikasi, dan pengguna diharapkan meninjau versi terbaru secara berkala.',
    },
    {
      'title': '7. Kontak & bantuan',
      'content':
          'Jika Anda memiliki pertanyaan atau kendala, silakan hubungi pengurus RT atau tim dukungan Smart RT.',
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
              title: 'Syarat & Ketentuan',
            ),
          ),

          // Konten utama
          Positioned(
            // Penyesuaian: Top position harus dihitung ulang untuk menentukan offset awal scroll.
            // Saat ini, Container ini memulai di headerH * 0.70 dari atas layar.
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
                // 2. Pasang ScrollController ke SingleChildScrollView
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  children: termsData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    // 3. Gunakan GlobalKey untuk setiap ExpansionTile
                    final GlobalKey expansionTileKey = GlobalKey();

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
                              // Pasang key ke ExpansionTile
                              key: expansionTileKey,
                              initiallyExpanded: controller.isExpanded(index),
                              onExpansionChanged: (expanded) {
                                controller.toggleExpansion(
                                  expanded ? index : -1,
                                );

                                // 4. Logika untuk Scroll
                                if (expanded) {
                                  // Perlu penundaan (delay) agar konten ter-render terlebih dahulu
                                  Future.delayed(
                                    const Duration(milliseconds: 300),
                                  ).then((_) {
                                    final RenderBox renderBox =
                                        expansionTileKey.currentContext
                                                ?.findRenderObject()
                                            as RenderBox;
                                    final double yPosition = renderBox
                                        .localToGlobal(Offset.zero)
                                        .dy;

                                    // Hitung offset yang diperlukan.
                                    // Kita kurangi yPosition dengan tinggi header Container
                                    // agar tile muncul di atas area scrollable.
                                    final double scrollOffset =
                                        _scrollController.offset +
                                        yPosition -
                                        (headerH * 0.70) -
                                        10; // -10 untuk sedikit padding

                                    _scrollController.animateTo(
                                      scrollOffset,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOut,
                                    );
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
