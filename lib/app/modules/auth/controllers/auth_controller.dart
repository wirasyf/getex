import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smart_rt/app/data/repository/auth_repository.dart';
import 'package:smart_rt/app/data/service/dio_service.dart';
import 'package:smart_rt/app/data/service/storage_service.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';


import 'package:smart_rt/app/routes/app_pages.dart';
import 'package:smart_rt/app/core/constant/colors/colors.dart' as app;

class AuthController extends GetxController {
  // Ganti DioService dengan Repository dan StorageService
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  // Controllers login
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Controllers register
  final regUsernameController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
  final regConfirmPasswordController = TextEditingController();

  // States
  final rememberMe = false.obs;
  final agreeToTerms = false.obs;
  final obscurePassword = true.obs;
  final obscureRegPassword = true.obs;
  final obscureRegConfirmPassword = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // // Check if already logged in
    // checkLoginStatus();

    // // TEST API CONNECTION
    // testApiConnection();
  }

  // TEST API CONNECTION - DIPERBARUI DENGAN TRY-CATCH
  Future<void> testApiConnection() async {
    print('🧪 ========== TEST API CONNECTION ==========');
    // Kita masih bisa mengakses baseUrl jika 'static'
    print('🧪 Base URL: ${DioService.baseUrl}');

    try {
      // Panggil REPOSITORY
      final result = await _authRepository.login(
        username: 'test123',
        password: 'password123',
      );
      
      // Jika berhasil, 'result' adalah data user
      print('✅ API Connection OK!');
      // 'result' adalah map 'data', jadi kita bisa langsung akses 'token'
      print('✅ Token received: ${result['token']}');
    } on ApiException catch (e) {
      // Tangkap error API yang spesifik
      print('❌ Test APIException: ${e.message}');
    } catch (e) {
      // Tangkap error lainnya
      print('❌ Test Unexpected Error: $e');
    }
    print('🧪 ========================================');
  }

  // Check login status - DIPERBARUI DENGAN STORAGESERVICE
  Future<void> checkLoginStatus() async {
    // Panggil STORAGE SERVICE
    final isLoggedIn = await _storageService.isLoggedIn();
    print('🔐 Is Logged In: $isLoggedIn');
    if (isLoggedIn) {
      // Auto navigate to home if already logged in
      Get.offAllNamed(Routes.HOME); // Sebaiknya di-enable
    }
  }

  // --- Toggle methods (Tidak berubah) ---
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRegPasswordVisibility() {
    obscureRegPassword.value = !obscureRegPassword.value;
  }

  void toggleRegConfirmPasswordVisibility() {
    obscureRegConfirmPassword.value = !obscureRegConfirmPassword.value;
  }
  // ------------------------------------

  // LOGIN - DIPERBARUI DENGAN TRY-CATCH
  Future<void> login() async {
    print('🔑 ========== LOGIN ATTEMPT ==========');
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    print('🔑 Username: $username');
    print('🔑 Password: ${password.isNotEmpty ? "*" : "empty"}');

    // Validation (Tidak berubah)
    if (username.isEmpty || password.isEmpty) {
      print('⚠ Validation failed: Empty fields');
      _showSnack('Error', 'Username dan password wajib diisi', app.appErrorMain);
      return;
    }

    print('🔄 Setting loading to true...');
    isLoading.value = true;

    try {
      print('📡 Calling API...');
      // Panggil REPOSITORY
      final userData = await _authRepository.login(
        username: username,
        password: password,
      );

      // --- SUKSES ---
      print('📥 API Result: $userData');
      print('✅ Login successful!');
      _showSnack('Berhasil', 'Login berhasil', app.appSuccessMain);

      // 'userData' adalah map 'data'
      final mustCompleteProfile = userData['must_complete_profile'] ?? false;
      print('👤 Must complete profile: $mustCompleteProfile');

      if (mustCompleteProfile) {
        print('🚀 Navigating to INPUT_PERSONALIZATION...');
        Get.offNamed(Routes.INPUT_PERSONALIZATION);
      } else {
        print('🚀 Navigating to HOME...');
        // Ganti ke HOME jika sudah selesai
        // Get.offNamed(Routes.HOME);
        // Sementara tetap ke personalization sesuai kode lama Anda:
         Get.offNamed(Routes.HOME);
      }
    } on ApiException catch (e) {
      // --- GAGAL (API) ---
      print('❌ Login failed: ${e.message}');
      _showSnack('Error', e.message, app.appErrorMain);
    } catch (e) {
      // --- GAGAL (Lainnya) ---
      print('❌ Login unexpected error: $e');
      _showSnack('Error', 'Terjadi kesalahan tidak terduga', app.appErrorMain);
    } finally {
      // --- SELALU DIJALANKAN ---
      isLoading.value = false;
      print('🔄 Loading set to false');
    }
    print('🔑 ====================================');
  }

  // REGISTER - DIPERBARUI DENGAN TRY-CATCH
  Future<void> register() async {
    print('📝 ========== REGISTER ATTEMPT ==========');
    final username = regUsernameController.text.trim();
    final email = regEmailController.text.trim();
    final password = regPasswordController.text.trim();
    final confirm = regConfirmPasswordController.text.trim();

    // Validations (Tidak berubah)
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Error', 'Semua field wajib diisi', app.appErrorMain);
      return;
    }
    // ... (validasi email, password, terms, dll tidak berubah) ...
    if (password != confirm) {
       _showSnack('Error', 'Password tidak cocok', app.appErrorMain);
       return;
    }
    if (!agreeToTerms.value) {
       _showSnack('Perhatian', 'Anda harus menyetujui Syarat dan Ketentuan', app.appPendingMain);
       return;
    }

    isLoading.value = true;
    print('📡 Calling register API...');

    try {
      // Panggil REPOSITORY
      final userData = await _authRepository.register(
        username: username,
        email: email,
        password: password,
        passwordConfirmation: confirm,
      );

      // --- SUKSES ---
      print('📥 Register Result: $userData');
      print('✅ Register successful!');
      _showSnack('Berhasil', 'Registrasi berhasil. Silakan login.', app.appSuccessMain);

      // Clear form
      regUsernameController.clear();
      regEmailController.clear();
      regPasswordController.clear();
      regConfirmPasswordController.clear();
      agreeToTerms.value = false;

      print('🚀 Navigating to LOGIN...');
      Get.offNamed(Routes.LOGIN);
    } on ApiException catch (e) {
      // --- GAGAL (API) ---
      print('❌ Register failed: ${e.message}');
      _showSnack('Error', e.message, app.appErrorMain);
    } catch (e) {
       // --- GAGAL (Lainnya) ---
      print('❌ Register unexpected error: $e');
      _showSnack('Error', 'Terjadi kesalahan tidak terduga', app.appErrorMain);
    } finally {
      // --- SELALU DIJALANKAN ---
      isLoading.value = false;
    }
    print('📝 ======================================');
  }

  // LOGOUT - DIPERBARUI
  Future<void> logout() async {
    isLoading.value = true;
    try {
      // Panggil REPOSITORY
      await _authRepository.logout();
      
      // Repository sudah menangani clear token
      _showSnack('Info', 'Anda telah logout', app.appInfoDark);
      Get.offAllNamed(Routes.LOGIN);

    } catch (e) {
      // Jika ada error saat logout, kita tetap paksa logout di sisi klien
      print('❌ Logout error: $e. Forcing logout anyway.');
      _showSnack('Info', 'Anda telah logout', app.appInfoDark);
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helper methods (Tidak berubah) ---

  void loginWithGoogle() {
    _showSnack(
      'Login Google',
      'Fitur login Google segera hadir',
      app.appInfoDark,
    );
  }

  void forgotPassword() {
    _showSnack(
      'Lupa Password',
      'Fitur reset password segera hadir',
      app.appPendingMain,
    );
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void openTerms() {
    _showSnack(
      'Syarat dan Ketentuan',
      'Menampilkan Syarat dan Ketentuan',
      app.appNeutralMain,
    );
  }

  void openPrivacyPolicy() {
    _showSnack(
      'Kebijakan Privasi',
      'Menampilkan Kebijakan Privasi',
      app.appNeutralMain,
    );
  }

  void openContentPolicy() {
    _showSnack(
      'Kebijakan Konten',
      'Menampilkan Kebijakan Konten',
      app.appNeutralMain,
    );
  }

  // Helper snackbar
  void _showSnack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: app.appTextSecond,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    regUsernameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regConfirmPasswordController.dispose();
    super.onClose();
  }
}