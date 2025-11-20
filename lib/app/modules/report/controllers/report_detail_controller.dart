import 'package:get/get.dart';
import '../../../data/repository/report_repository.dart';
import '../../../data/models/complaint_model.dart';
import '../../../data/exceptions/api_exception.dart';

class ReportDetailController extends GetxController {
  final ReportRepository _repo = Get.find<ReportRepository>();

  // State
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Data detail
  final complaintDetail = Rx<ComplaintModel?>(null);

  // ID dari argument
  late final String complaintId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    complaintId = args?['complaintId'] ?? '';

    if (complaintId.isEmpty) {
      errorMessage.value = "ID Pengaduan tidak ditemukan";
      return;
    }

    fetchDetail();
  }

  // =====================================================
  // FETCH DETAIL
  // =====================================================
  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await _repo.getComplaintDetail(complaintId);
      complaintDetail.value = data;
      print(data.status);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
