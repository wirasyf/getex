import 'package:dio/src/form_data.dart';
import 'package:get/get.dart' hide FormData;

import '../../../data/models/complaint_model.dart';
import '../../../data/repository/report_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class ReportController extends GetxController {
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  Future<void> setMonth(int month) async => selectedMonth.value = month;
  Future<void> setYear(int year) async => selectedYear.value = year;

  final complaints = <ComplaintModel>[].obs;
  final RxBool isLoading = false.obs;

  late ReportRepository _complaintsRepo;

  @override
  void onInit() {
    super.onInit();
    _complaintsRepo = Get.find<ReportRepository>();
    fetchComplaints();
  }

  // ======================================================
  // GET LIST
  // ======================================================
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;
      final result = await _complaintsRepo.getComplaints();
      complaints.assignAll(result);
    } catch (e) {
      print('ERROR COMPLAINT LIST: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data keluhan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // GET DETAIL
  // ======================================================
  Future<ComplaintModel?> getDetail(String id) async {
    try {
      isLoading.value = true;
      final result = await _complaintsRepo.getComplaintDetail(id);
      return result;
    } catch (e) {
      print('ERROR DETAIL: $e');
      Get.snackbar('Error', 'Gagal memuat detail keluhan');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // CREATE
  // ======================================================
  Future<void> createComplaint(FormData form) async {
    try {
      isLoading.value = true;

      final success = await _complaintsRepo.createComplaint(form);
      if (success) {
        await fetchComplaints();
        CustomPopup.show(
          Get.context!,
          title: 'Complain berhasil ditambahkan!',
          subtitle: 'Klik tutup untuk lanjut',
          type: PopupType.info,
          lottieAsset: 'assets/lottie/success.json',
          onClose: Get.back,
        );
      }
    } catch (e) {
      print('ERROR CREATE: $e');
      Get.snackbar('Error', 'Gagal membuat keluhan');
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // UPDATE
  // ======================================================
  Future<void> updateComplaint(String id, FormData form) async {
    try {
      isLoading.value = true;

      final success = await _complaintsRepo.updateComplaint(id, form);
      if (success) {
        await fetchComplaints();

        CustomPopup.show(
          Get.context!,
          title: 'Complain berhasil diubah!',
          subtitle: 'Klik tutup untuk lanjut',
          type: PopupType.info,
          lottieAsset: 'assets/lottie/success.json',
          onClose: Get.back,
        );
      }
    } catch (e) {
      print('ERROR UPDATE: $e');
      Get.snackbar('Error', 'Gagal mengubah keluhan');
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // DELETE
  // ======================================================
  Future<void> deleteComplaint(String id) async {
    try {
      isLoading.value = true;

      final success = await _complaintsRepo.deleteComplaint(id);
      if (success) {
        complaints.removeWhere((c) => c.id == id);

        CustomPopup.show(
          Get.context!,
          title: 'Complain berhasil dihapus!',
          subtitle: 'Klik tutup untuk lanjut',
          type: PopupType.info,
          lottieAsset: 'assets/lottie/success.json',
          onClose: Get.back,
        );
      }
    } catch (e) {
      print('ERROR DELETE: $e');
      Get.snackbar('Error', 'Gagal menghapus keluhan');
    } finally {
      isLoading.value = false;
    }
  }
}
