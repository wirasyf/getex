// app/modules/profile/controllers/edit_profile_controller.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/models/profile.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../data/service/dio_service.dart';

class EditProfileController extends GetxController {
  // --- Dependencies ---
  final ProfileController _profileController = Get.find<ProfileController>();
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final usernameController = TextEditingController(); // Untuk 'username'
  final fullNameController =
      TextEditingController(); // Untuk 'name' (Nama Lengkap)
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Display data (header)
  RxString displayName = ''.obs; // Akan diisi 'Nama Lengkap'
  RxString email = ''.obs;
  RxBool isLoading = false.obs;

  // Foto
  final Rx<String?> existingPhotoUrl = Rxn<String>();
  final Rx<XFile?> pickedImage = Rxn<XFile>();

  final Rx<DateTime?> pickedDateApi = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();

    // Header akan menampilkan Nama Lengkap
    fullNameController.addListener(
      () => displayName.value = fullNameController.text,
    );
    emailController.addListener(() => email.value = emailController.text);

    loadUserData();
  }

  /// Memuat data profil dari ProfileController
  void loadUserData() {
    final ProfileModel? profile = _profileController.profileModel.value;

    if (profile != null) {
      // SINKRONISASI: Muat kedua field nama
      usernameController.text = profile.username ?? '';
      fullNameController.text = profile.name ?? ''; // 'name' dari API

      // Atur header
      displayName.value = fullNameController.text.isNotEmpty
          ? fullNameController.text
          : usernameController.text; // Fallback ke username

      emailController.text = profile.email;
      email.value = emailController.text;

      phoneController.text = profile.phoneNumber ?? '';

      // Ambil URL LENGKAP dari getter ProfileController
      existingPhotoUrl.value = _profileController.photoUrl;

      // Logika 'birth_date' (DOB)
      if (profile.dob != null && profile.dob!.isNotEmpty) {
        try {
          final apiDate = DateFormat('yyyy-MM-dd').parse(profile.dob!);
          pickedDateApi.value = apiDate;
          dobController.text = DateFormat('dd/MM/yyyy').format(apiDate);
        } catch (e) {
          dobController.text = profile.dob!;
          if (kDebugMode) {
            print('Gagal mem-parsing tanggal lahir: ${profile.dob}');
          }
        }
      }
    }
  }

  // ... (showImageSourceDialog, pickImage, pickDate tidak berubah) ...
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        pickedImage.value = image;
        if (kDebugMode) print('Gambar dipilih: ${image.path}');
      }
    } catch (e) {
      if (kDebugMode) print('Gagal mengambil gambar: $e');
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        backgroundColor: app.appErrorMain,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: pickedDateApi.value ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      pickedDateApi.value = pickedDate;
      final formatter = DateFormat('dd/MM/yyyy');
      dobController.text = formatter.format(pickedDate);
    }
  }

  /// Simpan perubahan
  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      String dobForApi = '';
      if (pickedDateApi.value != null) {
        dobForApi = DateFormat('yyyy-MM-dd').format(pickedDateApi.value!);
      }

      // SINKRONISASI: Kirim kedua field nama
      final updatedMap = await _profileRepository.updateProfile(
        username: usernameController.text.trim(), // Mengirim 'username'
        fullName: fullNameController.text.trim(), // Mengirim 'name'
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        photo: pickedImage.value,
        dob: dobForApi, // Mengirim 'birth_date'
      );

      // Handle foto
      final newPhotoPath = (updatedMap['photo'] is String)
          ? updatedMap['photo'] as String
          : null;

      if (newPhotoPath != null && newPhotoPath.isNotEmpty) {
        existingPhotoUrl.value = '${DioService.storageBaseUrl}/$newPhotoPath';
      }
      pickedImage.value = null; // Wajib dibersihkan

      await CustomPopup.show(
        Get.context!,
        title: 'Perubahan berhasil disimpan!',
        subtitle: 'klik tutup untuk lanjut',
        type: PopupType.info,
        lottieAsset: 'assets/lottie/success.json',
        onClose: Get.back,
      );

      // Refresh data di ProfileController
      await _profileController.fetchProfile();
    } catch (e) {
      if (kDebugMode) print('Error saveChanges: $e');
      Get.snackbar(
        'Gagal Menyimpan',
        e.toString(),
        backgroundColor: app.appErrorMain,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    fullNameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
