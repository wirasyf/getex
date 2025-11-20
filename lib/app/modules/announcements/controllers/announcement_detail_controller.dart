import 'package:get/get.dart';
import '../../../data/models/announcement_model.dart';
import '../../../data/repository/announcement_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class AnnouncementDetailController extends GetxController {
  final repo = Get.find<AnnouncementRepository>();

  RxBool isLoading = true.obs;
  Rxn<AnnouncementModel> detail = Rxn<AnnouncementModel>();
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
      final result = await repo.getAnnouncementDetail(id);
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
