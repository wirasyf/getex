import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';
import 'package:smart_rt/app/data/service/dio_service.dart';
import 'package:smart_rt/app/data/service/storage_service.dart';


/// Repository untuk mengelola semua endpoint terkait otentikasi.
class AuthRepository extends GetxService {
  late DioService _dioService;
  late StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    _dioService = Get.find<DioService>();
    _storageService = Get.find<StorageService>();
  }

  /// Login dan mengembalikan data user jika berhasil.
  /// Melempar [ApiException] jika gagal.
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dioService.dio.post(
        '/family/login',
        data: {'username': username, 'password': password},
      );

      if (response.data is Map && response.data['success'] == true) {
        final responseData = response.data['data'];
        if (responseData != null && responseData['token'] != null) {
          await _storageService.saveToken(responseData['token']);
          return responseData;
        } else {
          throw ApiException('Token tidak ditemukan dalam respons');
        }
      }
      throw ApiException(
          response.data['meta']?['message'] ?? 'Username atau password salah');
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// Register dan mengembalikan data user jika berhasil.
  /// Melempar [ApiException] jika gagal.
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioService.dio.post(
        '/family/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.data is Map && response.data['success'] == true) {
        return response.data['data'];
      }
      throw ApiException(
          response.data['meta']?['message'] ?? 'Registrasi gagal');
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// Mengambil profil user.
  /// Melempar [ApiException] jika gagal.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dioService.dio.get('/family/me');

      if (response.data is Map && response.data['success'] == true) {
        return response.data['data'];
      }
      throw ApiException(
          response.data['meta']?['message'] ?? 'Gagal mengambil profil');
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// Logout user. Selalu menghapus token lokal.
  Future<void> logout() async {
    try {
      await _dioService.dio.post('/family/logout');
    } on DioException catch (e) {
      if (kDebugMode) print('API logout error (token tetap dihapus): $e');
    } catch (e) {
      if (kDebugMode) print('Unexpected logout error (token tetap dihapus): $e');
    }
    
    // Selalu hapus token lokal
    await _storageService.clearToken();
  }
}