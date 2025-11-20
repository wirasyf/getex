import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repository/event_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class EventsController extends GetxController {
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  Future<void> setMonth(int month) async => selectedMonth.value = month;
  Future<void> setYear(int year) async => selectedYear.value = year;

  final events = <EventModel>[].obs;
  final RxBool isLoading = false.obs;

  late EventsRepository _eventsRepo;

  @override
  void onInit() {
    super.onInit();
    _eventsRepo = Get.find<EventsRepository>();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final result = await _eventsRepo.getEvents();
      events.assignAll(result);
    } catch (e) {
      print('ERROR EVENT: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat event',
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
}
