// app/modules/profile/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
// Hapus import MapsController (tidak diperlukan di sini)
import 'package:smart_rt/app/data/service/dio_service.dart'; 
import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/models/profile.dart'; // Import model yang sudah diperbaiki
import '../../../data/repository/auth_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../widgets/pop_up/custom_popup_confirm.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  
  final Rx<ProfileModel?> profileModel = Rxn<ProfileModel>();
  final username = 'Loading...'.obs; // Ini untuk header, akan diisi 'username'
  final email = 'Loading...'.obs;
  final isLoading = true.obs;

  String get photoUrl {
    final String? relativePath = profileModel.value?.photo;
    if (relativePath == null || relativePath.isEmpty) return ''; 
    if (relativePath.startsWith('http')) return relativePath;
    return '${DioService.storageBaseUrl}/$relativePath';
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fungsi ini sekarang akan berhasil berkat perbaikan ProfileModel
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final profileData = await _profileRepository.getProfile();
      if (kDebugMode) print('✅ Profile Data Received: $profileData');

      final userData = profileData['user'] as Map<String, dynamic>?;
      if (userData == null) {
        throw Exception('Data user tidak ditemukan');
      }
      
      final familyData = userData['family'] as Map<String, dynamic>?;
      if (familyData != null) {
        userData['address'] = familyData;
      }

      final profile = ProfileModel.fromJson(userData);
      profileModel.value = profile; // Data (termasuk alamat) tersimpan di sini

      // --- SINKRONISASI PERBAIKAN ---
      // Ambil kedua field dari model
      final apiName = profile.name; // Ini adalah "Nama Lengkap" (cth: "Bla")
      final apiUsername = profile.username; // Ini adalah "Username" (cth: "user")
      email.value = profile.email;

      // Prioritaskan 'name'. Jika 'name' kosong, gunakan 'username'.
      if (apiName != null && apiName.isNotEmpty) {
        username.value = apiName; // Tampilkan "Nama Lengkap"
      } else if (apiUsername != null && apiUsername.isNotEmpty) {
        username.value = apiUsername; // Fallback ke "Username"
      } else {
        // Fallback terakhir jika keduanya kosong
        username.value = profile.email.split('@').first;
      }
      // --- BATAS PERBAIKAN ---

    } catch (e) {
      if (kDebugMode) print('❌ Error fetching profile: $e');
      username.value = 'User Error';
      email.value = 'error@load.com';
      Get.snackbar(
        'Error',
        'Gagal memuat profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: app.appErrorMain,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ... (logout tidak berubah) ...
  Future<void> logout() async {
    final result = await CustomConfirmationPopup.show(
      Get.context!,
      title: 'Konfirmasi Keluar',
      subtitle: 'Apakah Anda yakin ingin keluar dari akun ini?',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      imageAsset: 'assets/ilustration/question.png',
    );

    if (result == true) {
      await _authRepository.logout();
      await Get.offAllNamed(Routes.LOGIN);
    }
  }

  void goToPaymentHistory() => Get.toNamed('/payment-history');
  void goToEditProfile() => Get.toNamed('/edit-profile');
  void goToTerms() => Get.toNamed('/terms');
  void goToFaq() => Get.toNamed(Routes.FAQ);
  
  /// SINKRONISASI: Alur ini sekarang akan berfungsi
  void goToLocation() {
    // 1. Ambil data alamat dari model (yang sekarang sudah terisi)
    final address = profileModel.value?.address;

    // 2. Kirim 'address' sebagai argumen.
    //    MapsController akan mengambil ini saat onInit.
    Get.toNamed(Routes.EDIT_MAP, arguments: address);
  }
  
  void goToEditPassword() => Get.toNamed(Routes.EDIT_PASSWORD);
}
