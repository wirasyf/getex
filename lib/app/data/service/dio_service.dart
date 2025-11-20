import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;

import 'storage_service.dart';

class DioService
    extends
        GetxService {
  late Dio dio;
  late StorageService _storageService;

  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String storageBaseUrl = 'http://127.0.0.1:8000/storage';

  // static const String baseUrl = 'http://192.168.203.143:8000/api';
  // static const String storageBaseUrl = 'http://192.168.203.143:8000/storage';

  @override
  void onInit() {
    super.onInit();
    _storageService =
        Get.find<
          StorageService
        >();

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(
          seconds: 30,
        ),
        receiveTimeout: const Duration(
          seconds: 30,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (
              options,
              handler,
            ) async {
              final token = await _storageService.getToken();
              if (token !=
                  null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              if (kDebugMode) {
                print(
                  '🚀 REQUEST: ${options.method} ${options.uri}',
                );
                print(
                  '📦 DATA: ${options.data}',
                );
              }
              return handler.next(
                options,
              );
            },
        onResponse:
            (
              response,
              handler,
            ) {
              if (kDebugMode) {
                print(
                  '✅ RESPONSE: ${response.statusCode}',
                );
                print(
                  '📥 DATA: ${response.data}',
                );
              }
              return handler.next(
                response,
              );
            },
        onError:
            (
              error,
              handler,
            ) {
              if (kDebugMode) {
                print(
                  '❌ DIO ERROR: ${error.response?.statusCode}',
                );
                print(
                  '❌ ERROR DATA: ${error.response?.data}',
                );
                print(
                  '❌ ERROR MESSAGE: ${error.message}',
                );
              }
              return handler.next(
                error,
              );
            },
      ),
    );
  }

  String handleError(
    DioException error,
  ) {
    if (error.response !=
            null &&
        error.response?.data
            is Map) {
      final data = error.response!.data;
      if (data['meta']
              is Map &&
          data['meta']['message'] !=
              null) {
        return data['meta']['message'];
      }
      if (data['message'] !=
          null) {
        return data['message'];
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Koneksi timeout, cek internet Anda';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Pastikan HP dan PC di WiFi yang sama.';
      default:
        return 'Terjadi kesalahan: ${error.message ?? 'Unknown error'}';
    }
  }
}
