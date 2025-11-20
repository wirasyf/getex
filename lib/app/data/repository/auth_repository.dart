import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../exceptions/api_exception.dart';
import '../service/dio_service.dart';
import '../service/storage_service.dart';

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
        response.data['meta']?['message'] ?? 'Username atau password salah',
      );
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
        response.data['meta']?['message'] ?? 'Registrasi gagal',
      );
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
      if (kDebugMode)
        print('Unexpected logout error (token tetap dihapus): $e');
    }

    // Selalu hapus token lokal
    await _storageService.clearToken();
  }

    Future<String> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      // PERBAIKAN 1: Ubah .post menjadi .put sesuai dengan error log
      final response = await _dioService.dio.put(
        '/family/update-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          // PERBAIKAN: Sesuaikan nama field agar cocok dengan aturan 'confirmed' di Laravel
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['meta']?['message'] ??
            'Password berhasil diupdate';
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Update password gagal',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// [Endpoint: /family/forgot-password]
  /// Meminta kode reset password dikirim ke email
  Future<String> forgotPassword({required String email}) async {
    try {
      final response = await _dioService.dio.post(
        '/family/forgot-password',
        data: {'email': email},
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['meta']?['message'] ?? 'Kode verifikasi terkirim';
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal mengirim kode',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// [Endpoint: /family/verify-reset-password]
  /// Memverifikasi kode yang dikirim ke email
  Future<String> verifyResetPassword({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dioService.dio.post(
        '/family/verify-reset-password',
        data: {
          'email': email,
          'code': code,
        },
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['meta']?['message'] ?? 'Verifikasi berhasil';
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Verifikasi kode gagal',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// [Endpoint: /family/reset-password]
  /// Mengatur password baru setelah verifikasi berhasil
  Future<String> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioService.dio.post(
        '/family/reset-password',
        data: {
          'email': email,
          // PERBAIKAN 2: Ubah 'reset_code' menjadi 'code' agar sesuai dengan FamilyAuthService.php
          'code': code,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['meta']?['message'] ?? 'Password berhasil direset';
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Reset password gagal',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }
}
