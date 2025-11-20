import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../exceptions/api_exception.dart';
import '../models/announcement_model.dart';
import '../service/dio_service.dart';

class AnnouncementRepository extends GetxService {
  late DioService _dioService;

  @override
  void onInit() {
    super.onInit();
    _dioService = Get.find<DioService>();
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await _dioService.dio.get('/family/announcements');

      if (response.data is Map && response.data['success'] == true) {
        // Ambil List data
        final List list = response.data['data']?['data'] ?? [];

        // ✨ PERBAIKAN UTAMA: Casting item secara eksplisit
        return list
            .map((item) {
              if (item is Map<String, dynamic>) {
                return AnnouncementModel.fromJson(item);
              }
              // Jika item BUKAN Map, kita lewati atau lempar error yang lebih spesifik
              print('Peringatan: Item list pengumuman bukan Map: $item');
              return null;
            })
            .whereType<AnnouncementModel>() // Hanya ambil yang berhasil di-parse
            .toList();
      }

      // Jika success=false, ambil pesan error dari meta
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal mengambil data pengumuman',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      // Catch-all untuk error parsing atau error tak terduga lainnya
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// Ambil detail pengumuman (show)
  Future<AnnouncementModel> getAnnouncementDetail(String id) async {
    try {
      final response = await _dioService.dio.get('/family/announcements/$id');

      if (response.data is Map && response.data['success'] == true) {
        final data = response.data['data'];

        if (data == null || data is! Map<String, dynamic>) {
          // ✨ PERBAIKAN KECIL: Memastikan data bukan null dan bertipe Map
          throw ApiException('Data pengumuman tidak valid atau tidak ditemukan');
        }

        // ✅ Sudah aman di sini karena sudah dipastikan data adalah Map<String, dynamic>
        return AnnouncementModel.fromJson(data);
      }

      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal mengambil detail pengumuman',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }
}