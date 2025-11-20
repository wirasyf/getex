import 'package:get/get.dart';
import 'package:smart_rt/app/data/models/announcement_model.dart';
import 'package:smart_rt/app/data/repository/profile_repository.dart';
import 'package:smart_rt/app/data/models/set_identity_request_model.dart';
// Import lain yang mungkin Anda perlukan, misal untuk navigasi
// import 'package:smart_rt/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;

  ProfileController(this.repository);

  /// Menyimpan data profil LENGKAP
  var profile = Rx<UserModel?>(null);

  /// Status loading untuk mengambil data
  var isLoading = false.obs;

  /// Status loading spesifik untuk proses update/submit
  var isUpdating = false.obs;

  /// Pesan error
  var errorMessage = Rx<String?>(null);

  /// Ambil data profil
  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      errorMessage(null); // Bersihkan error sebelumnya
      final result = await repository.getProfile();
      profile(result); // Simpan data profil ke state 'profile'
      print('✅ Berhasil memuat data profil: ${result.name}');
    } catch (e) {
      print('❌ ERROR fetchProfile: $e');
      errorMessage('Gagal memuat data profil: $e');
      Get.snackbar('Error', 'Gagal memuat data profil');
    } finally {
      isLoading(false);
    }
  }

  /// Method untuk SET IDENTITY (dipanggil dari UI)
  /// Method ini menerima data mentah dari TextEditingControllers di UI Anda
  Future<bool> setIdentity({
    required String name,
    required String status,
    required String gender,
    required String birthDate, // (String YYYY-MM-DD)
    required String phoneNumber,
    required String rtCode,
  }) async {
    print('🧩 Controller: submitting identity...');

    // 1. Buat Request Model
    final requestModel = SetIdentityRequestModel(
      name: name,
      status: status,
      gender: gender,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      rtCode: rtCode,
    );

    try {
      isUpdating(true); // Gunakan loading spesifik
      errorMessage(null);

      // 2. Panggil Repository
      final updatedProfile = await repository.setIdentity(requestModel);

      // 3. Sinkronkan state
      // API mengembalikan profile baru, update state 'profile' kita
      profile(updatedProfile);

      print('✅ Berhasil update identitas. Nama baru: ${updatedProfile.name}');
      Get.snackbar('Berhasil', 'Data identitas berhasil diperbarui.');
      return true;
      // Contoh navigasi setelah berhasil
      // Get.offNamed(Routes.VERIFICATION); // Sesuai contoh Anda sebelumnya
    } catch (e) {
      print('❌ ERROR submitIdentity: $e');
      errorMessage('Gagal menyimpan data: $e');
      Get.snackbar('Error', 'Gagal menyimpan data: $e');
      isUpdating(false);
      return false;
    }
  }

  /// Refresh data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  // ---
  // Nanti Anda bisa tambahkan method lain di sini:
  // Future<void> changePassword(String oldPass, String newPass) async { ... }
  // ---
}
