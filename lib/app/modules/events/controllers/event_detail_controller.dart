import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repository/event_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class EventDetailController extends GetxController {
  final repo = Get.find<EventsRepository>();

  RxBool isLoading = true.obs;
  Rxn<EventModel> detail = Rxn<EventModel>();
  late String id;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments;
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      final result = await repo.getEventsDetail(id);
      detail.value = result;
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
