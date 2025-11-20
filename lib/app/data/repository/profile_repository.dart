import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/maps.dart';
import '../service/dio_service.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import 'package:smart_rt/app/data/exceptions/api_exception.dart';

class ProfileRepository extends GetxService {
  late DioService _dioService;

  @override
  void onInit() {
    super.onInit();
    _dioService = Get.find<DioService>();
  }

  /// Mengambil data profil user.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dioService.dio.get('/family/me');
      if (response.data is Map && response.data['success'] == true) {
        if (kDebugMode) print('Profile data fetched successfully.');
        return response.data['data'] as Map<String, dynamic>;
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal mengambil data profil',
      );
    } on DioException catch (e) {
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga saat mengambil profil: $e');
    }
  }

  /// [Endpoint: /family/set-address]
  /// Menyimpan alamat baru (saat registrasi)
  Future<Map<String, dynamic>> setAddress({
    required AddressModel address,
  }) async {
    try {
      final response = await _dioService.dio.post(
        '/family/set-address',
        data: address.toJson(),
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['data'];
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal menyimpan alamat',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiException(
          e.response?.data['meta']?['message'] ?? 'Data tidak valid',
        );
      }
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// [Endpoint: /family/update-address]
  /// Memperbarui alamat yang sudah ada
  Future<Map<String, dynamic>> updateAddress({
    required AddressModel address,
  }) async {
    try {
      // SINKRONISASI: Pastikan ini adalah dio.put
      final response = await _dioService.dio.put(
        '/family/update-address', // Endpoint baru untuk updateAddress
        data: address.toJson(),
      );
      if (response.data is Map && response.data['success'] == true) {
        return response.data['data'];
      }
      throw ApiException(
        response.data['meta']?['message'] ?? 'Gagal memperbarui alamat',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiException(
          e.response?.data['meta']?['message'] ?? 'Data tidak valid',
        );
      }
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// [Endpoint: /family/update-profile]
  /// SINKRONISASI: Mengirim 'name' (Nama Lengkap) dan 'username'
  Future<Map<String, dynamic>> updateProfile({
    required String username, // Field 'Username'
    required String fullName, // Field 'Nama Lengkap'
    required String email,
    required String phoneNumber,
    required String dob, // 'birth_date'
    XFile? photo,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'username': username, // Kirim 'username'
        'name': fullName, // Kirim 'name'
        'email': email,
        'phone_number': phoneNumber,
        'birth_date': dob,
        '_method': 'PUT',
      };

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        dataMap['photo'] = MultipartFile.fromBytes(bytes, filename: photo.name);
      }

      final formData = FormData.fromMap(dataMap);

      final response = await _dioService.dio.post(
        '/family/update-profile',
        data: formData,
      );

      if (response.data is Map && response.data['success'] == true) {
        if (kDebugMode) print('✅ Profile berhasil diupdate');
        return response.data['data'];
      }

      if (response.data is Map && response.data['meta']?['message'] != null) {
        throw ApiException(response.data['meta']['message']);
      }

      throw ApiException('Gagal memperbarui profil');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 &&
          e.response?.data['meta']?['message'] != null) {
        throw ApiException(e.response!.data['meta']['message']);
      }
      throw ApiException(_dioService.handleError(e));
    } catch (e) {
      throw ApiException('Error tidak terduga saat update profil: $e');
    }
  }
}
