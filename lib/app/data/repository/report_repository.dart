import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData;

import '../exceptions/api_exception.dart';
import '../models/complaint_model.dart';
import '../service/dio_service.dart';

class ReportRepository extends GetxService {
  late DioService _dioService;

  @override
  void onInit() {
    super.onInit();
    _dioService = Get.find<DioService>();
  }

  // ======================================================
  // GET LIST COMPLAINTS
  // ======================================================
  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final response = await _dioService.dio.get('/family/complaints');

      if (response.data is Map && response.data['success'] == true) {
        final List list = response.data['data']?['data'] ?? [];

        return list
            .map((item) {
              if (item is Map<String, dynamic>) {
                return ComplaintModel.fromJson(item);
              }
              if (kDebugMode) {
                print("Peringatan: Item complaint bukan Map: $item");
              }
              return null;
            })
            .whereType<ComplaintModel>()
            .toList();
      }

      throw ApiException(
        response.data['meta']?['message'] ??
            'Gagal mengambil data complaint',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException("Error tidak terduga: $e");
    }
  }

  // ======================================================
  // GET DETAIL COMPLAINT
  // ======================================================
  Future<ComplaintModel> getComplaintDetail(String id) async {
    try {
      final response = await _dioService.dio.get('/family/complaints/$id');

      if (response.data is Map && response.data['success'] == true) {
        final data = response.data['data'];

        if (data == null || data is! Map<String, dynamic>) {
          throw ApiException('Data complaint tidak valid atau tidak ditemukan');
        }

        return ComplaintModel.fromJson(data);
      }

      throw ApiException(
        response.data['meta']?['message'] ??
            'Gagal mengambil detail complaint',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException("Error tidak terduga: $e");
    }
  }

  // ======================================================
  // CREATE COMPLAINT (POST)
  // ======================================================
  Future<bool> createComplaint(FormData body) async {
    try {
      final response = await _dioService.dio.post(
        '/family/complaints',
        data: body,
      );

      if (response.data is Map && response.data['success'] == true) {
        return true;
      }

      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal membuat complaint',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException("Error tidak terduga: $e");
    }
  }

  // ======================================================
  // UPDATE COMPLAINT (PUT/PATCH)
  // ======================================================
  Future<bool> updateComplaint(String id, FormData body) async {
    try {
      final response = await _dioService.dio.post(
        '/family/complaints/$id?_method=PUT',
        data: body,
      );

      if (response.data is Map && response.data['success'] == true) {
        return true;
      }

      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal update complaint',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException("Error tidak terduga: $e");
    }
  }

  // ======================================================
  // DELETE COMPLAINT
  // ======================================================
  Future<bool> deleteComplaint(String id) async {
    try {
      final response =
          await _dioService.dio.delete('/family/complaints/$id');

      if (response.data is Map && response.data['success'] == true) {
        return true;
      }

      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal menghapus complaint',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException("Error tidak terduga: $e");
    }
  }
}
