import 'package:get/get.dart';
import '../../../data/models/announcement_model.dart';
import '../../../data/repository/announcement_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class AnnouncementsController extends GetxController {
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  Future<void> setMonth(int month) async => selectedMonth.value = month;
  Future<void> setYear(int year) async => selectedYear.value = year;

  final announcements = <AnnouncementModel>[].obs;
  final RxBool isLoading = false.obs;

  late AnnouncementRepository _repoAnnouncements;
  Future<void> fetchAnnouncements() async {
    try {
      isLoading.value = true;
      final result = await _repoAnnouncements.getAnnouncements();
      announcements.assignAll(result);
    } catch (e) {
      print('ERROR ANNOUNCEMENT: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat pengumuman',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    await CustomPopup.show(
      Get.context!,
      title: 'Pengingat berhasil ditambahkan!',
      subtitle: 'Klik tutup untuk lanjut',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _repoAnnouncements = Get.find<AnnouncementRepository>();
    fetchAnnouncements();
  }
}
