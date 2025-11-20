import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../exceptions/api_exception.dart';
import '../models/event_model.dart';
import '../service/dio_service.dart';

class EventsRepository extends GetxService {
  late DioService _dioService;

  @override
  void onInit() {
    super.onInit();
    _dioService = Get.find<DioService>();
  }

  Future<List<EventModel>> getEvents() async {
    try {
      final response = await _dioService.dio.get('/family/events');

      if (response.data is Map && response.data['success'] == true) {
        final List list = response.data['data']?['data'] ?? [];
        return list
            .map((item) {
              if (item is Map<String, dynamic>) {
                return EventModel.fromJson(item);
              }
              if (kDebugMode) {
                print('Peringatan: Item list event bukan Map: $item');
              }
              return null;
            })
            .whereType<EventModel>()
            .toList();
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal mengambil data event',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  Future<EventModel> getEventsDetail(String id) async {
    try {
      final response = await _dioService.dio.get('/family/events/$id');

      if (response.data is Map && response.data['success'] == true) {
        final data = response.data['data'];

        if (data == null || data is! Map<String, dynamic>) {
          throw ApiException(
            'Data event tidak valid atau tidak ditemukan',
          );
        }

        return EventModel.fromJson(data);
      }

      throw ApiException(
        response.data['meta']?['message'] ??
            'Gagal mengambil detail event',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }
}
