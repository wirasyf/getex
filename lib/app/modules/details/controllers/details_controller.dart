import 'package:get/get.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class DetailsController extends GetxController {
  final announcements = <Map<String, dynamic>>[].obs;
  final events = <Map<String, dynamic>>[].obs;
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  // ignore: use_setters_to_change_properties
  void setMonth(int month) => selectedMonth.value = month;
  // ignore: use_setters_to_change_properties
  void setYear(int year) => selectedYear.value = year;

  // Data Anouncement
  void loadAnnouncements() {
    announcements.assignAll([
      {
        'title': 'Tahlilan malam jumat',
        'subtitle': '25/10/2025\n18.00 WIB',
        'rtText': 'RT 10',
        'dateTime': '25/10/2025 - 18.00 WIB',
        'location': 'Rumah Pak Mamat',
        'description':
            'Diharapkan hadir setelah Magrib untuk membacakan Yasin & Tahlil di rumah Pak Mamat.',
      },
      {
        'title': 'Peringatan! Sampah menumpuk',
        'subtitle': 'Segera dibersihkan sebelum jam 10.00 WIB',
        'rtText': 'RT 10',
        'dateTime': '24/10/2025 - 10.00 WIB',
        'location': 'Setiap rumah warga RT 10',
        'description':
            'Diharapkan seluruh warga membersihkan sampah rumah masing-masing sebelum pukul 10.00 WIB.',
      },
      {
        'title': 'Rapat RT',
        'subtitle': '28/10/2025\n19.30 WIB',
        'rtText': 'RT 10',
        'dateTime': '28/10/2025 - 19.30 WIB',
        'location': 'Balai Warga RT 10',
        'description':
            'Rapat membahas kegiatan akhir tahun dan pembentukan panitia lomba. Harap semua ketua lingkungan hadir.',
      },
      {
        'title': 'Pemadaman Listrik',
        'subtitle':
            'PLN akan melakukan pemadaman sementara pukul 13.00–15.00 WIB',
        'rtText': 'RT 10',
        'dateTime': '22/10/2025 - 13.00–15.00 WIB',
        'location': 'Seluruh wilayah RT 10',
        'description':
            'PLN akan melakukan perawatan jaringan listrik. Mohon warga bersiap dan matikan peralatan elektronik.',
      },
    ]);
  }

  // Data Event
  void loadEvents() {
    events.assignAll([
      {
        'title': 'Lomba 17 Agustus',
        'subtitle': 'Rentang acara\n01–20 Agustus 2025',
        'rtText': 'RT 10',
        'dateTime': '01–20 Agustus 2025',
        'location': 'Lapangan RT 10',
        'description':
            'Perlombaan untuk memperingati HUT RI ke-80. Terdapat berbagai lomba anak-anak dan dewasa.',
      },
      {
        'title': 'Bazar UMKM Warga',
        'subtitle': 'Tanggal 12–14 September 2025\nLapangan RT 10',
        'rtText': 'RT 10',
        'dateTime': '12–14 September 2025',
        'location': 'Lapangan RT 10',
        'description':
            'Bazar yang diadakan untuk mendukung produk UMKM warga sekitar. Silakan datang dan berpartisipasi.',
      },
      {
        'title': 'Jalan Sehat',
        'subtitle': '05 Oktober 2025\nMulai 06.30 WIB',
        'rtText': 'RT 10',
        'dateTime': '05/10/2025 - 06.30 WIB',
        'location': 'Start dari Balai RT 10',
        'description':
            'Acara jalan sehat bersama keluarga. Peserta akan mendapatkan kupon doorprize menarik.',
      },
      {
        'title': 'Rapat Persiapan Tahun Baru',
        'subtitle': '28 Desember 2025\nBalai RW 03',
        'rtText': 'RT 10',
        'dateTime': '28/12/2025 - 19.00 WIB',
        'location': 'Balai RW 03',
        'description':
            'Rapat koordinasi menjelang acara pergantian tahun baru. Diharapkan perwakilan setiap RT hadir.',
      },
    ]);
  }

  Future<void> saveChanges() async {
    await CustomPopup.show(
      Get.context!,
      title: 'Pengingat berhasil ditambahkan!',
      subtitle: 'klik tutup untuk lanjut',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
    loadEvents();
  }
}
