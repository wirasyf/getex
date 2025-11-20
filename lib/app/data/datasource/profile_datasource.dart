import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_rt/app/data/models/announcement_model.dart';
import 'package:smart_rt/app/data/service/dio_service.dart';
import '../exceptions/api_exception.dart';

class ProfileDataSource {
  // Ganti ApiService -> DioService
  final DioService dioService;

  // Update constructor
  ProfileDataSource(this.dioService);

  /// Ambil data profil pengguna saat ini
  /// Melempar [ApiException] jika gagal.
  Future<UserModel> getProfile() async {
    print('🔵 Fetching user profile...');
    try {
      // Asumsi endpoint untuk mengambil profil adalah '/profile'
      // Ganti api.dio -> dioService.dio
      final response = await dioService.dio.get('/profile'); 
      print('🟢 Response: ${response.statusCode} - ${response.data}');

      // Adaptasi logika dari AuthRepository
      if (response.data is Map && response.data['success'] == true) {
        final profileData = response.data['data'];
        if (profileData != null) {
          print('✅ Parsed user profile');
          return UserModel.fromJson(profileData);
        } else {
          // Kasus aneh jika success: true tapi data null
          throw ApiException('Data profil tidak ditemukan dalam respons');
        }
      }
      // Gagal jika success: false atau format tidak dikenal
      throw ApiException(
          response.data['meta']?['message'] ?? 'Gagal mengambil profil');

    } on DioException catch (e) {
      print('🔴 Dio error fetching profile: ${e.message}');
      // Gunakan error handler dari DioService
      throw ApiException(dioService.handleError(e));
    } catch (e, s) {
      print('🔴 Unknown error fetching profile: $e');
      if (kDebugMode) {
        print(s);
      }
      throw ApiException('Error tidak terduga: $e');
    }
  }

  /// Kirim (set) data identitas
  /// Menerima Map dan mengembalikan ProfileModel yang sudah di-update
  /// Melempar [ApiException] jika gagal.
  Future<UserModel> setIdentity(Map<String, dynamic> data) async {
    print('🔵 Setting user identity...');
    try {
      // Asumsi endpoint untuk 'set identity' adalah '/profile/set-identity'
      // Ganti api.dio -> dioService.dio
      final response = await dioService.dio.post('/family/set-identity', data: data);
      print('🟢 Response: ${response.statusCode} - ${response.data}');

      // Adaptasi logika dari AuthRepository
      if (response.data is Map && response.data['success'] == true) {
        final updatedData = response.data['data'];
        if (updatedData != null) {
          print('✅ Parsed updated profile');
          return UserModel.fromJson(updatedData);
        } else {
          throw ApiException('Data profil yang diperbarui tidak ditemukan');
        }
      }
       // Gagal jika success: false atau format tidak dikenal
      throw ApiException(
          response.data['meta']?['message'] ?? 'Gagal menyimpan identitas');

    } on DioException catch (e) {
      print('🔴 Dio error setting identity: ${e.message}');
      // Gunakan error handler dari DioService
      throw ApiException(dioService.handleError(e));
    } catch (e, s) {
      print('🔴 Unknown error setting identity: $e');
      if (kDebugMode) {
        print(s);
      }
      throw ApiException('Error tidak terduga: $e');
    }
  }
  
  // ---
  // Nanti Anda bisa tambahkan method lain di sini:
  // Future<void> changePassword(Map<String, dynamic> passData) async { ... }
  // Future<String> updateProfilePicture(FormData imageData) async { ... }
  // ---
}