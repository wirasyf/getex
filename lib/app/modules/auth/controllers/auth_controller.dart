import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../data/exceptions/api_exception.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../data/service/dio_service.dart';
import '../../../data/service/storage_service.dart';
import '../../../routes/app_pages.dart';

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
    checkLoginStatus();
  }

  Future<void> testApiConnection() async {
    print('🧪 ========== TEST API CONNECTION ==========');
    print('🧪 Base URL: ${DioService.baseUrl}');
    try {
      final result = await _authRepository.login(
        username: 'test123',
        password: 'password123',
      );
      print('✅ API Connection OK!');
      print('✅ Token received: ${result['token']}');
    } on ApiException catch (e) {
      print('❌ Test APIException: ${e.message}');
    } catch (e) {
      print('❌ Test Unexpected Error: $e');
    }
    print('🧪 ========================================');
  }

  // Check login status
  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _storageService.isLoggedIn();
    print('🔐 Is Logged In: $isLoggedIn');
    if (isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // --- Toggle methods ---
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

  // LOGIN
  Future<void> login() async {
    print('🔑 ========== LOGIN ATTEMPT ==========');
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnack(
        'Error',
        'Username dan password wajib diisi',
        app.appErrorMain,
      );
      return;
    }

    isLoading.value = true;

    try {
      final userData = await _authRepository.login(
        username: username,
        password: password,
      );

      print('✅ Login successful!');
      _showSnack('Berhasil', 'Login berhasil', app.appSuccessMain);

      final mustCompleteProfile = userData['must_complete_profile'] ?? false;
      print('👤 Must complete profile: $mustCompleteProfile');

      if (mustCompleteProfile) {
        // Asumsi INPUT_PERSONALIZATION adalah halaman input nama, DOB, dll
        // Dan setelah itu baru ke INPUT_MAP
        Get.offNamed(Routes.INPUT_PERSONALIZATION);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } on ApiException catch (e) {
      print('❌ Login failed: ${e.message}');
      _showSnack('Error', e.message, app.appErrorMain);
    } catch (e) {
      print('❌ Login unexpected error: $e');
      _showSnack('Error', 'Terjadi kesalahan tidak terduga', app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
    print('🔑 ====================================');
  }

  // REGISTER
  Future<void> register() async {
    print('📝 ========== REGISTER ATTEMPT ==========');
    final username = regUsernameController.text.trim();
    final email = regEmailController.text.trim();
    final password = regPasswordController.text.trim();
    final confirm = regConfirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showSnack('Error', 'Semua field wajib diisi', app.appErrorMain);
      return;
    }
    if (password != confirm) {
      _showSnack('Error', 'Password tidak cocok', app.appErrorMain);
      return;
    }
    if (!agreeToTerms.value) {
      _showSnack(
        'Perhatian',
        'Anda harus menyetujui Syarat dan Ketentuan',
        app.appPendingMain,
      );
      return;
    }

    isLoading.value = true;
    print('📡 Calling register API...');

    try {
      final userData = await _authRepository.register(
        username: username,
        email: email,
        password: password,
        passwordConfirmation: confirm,
      );

      print('✅ Register successful: $userData');
      _showSnack(
        'Berhasil',
        'Registrasi berhasil. Silakan login.',
        app.appSuccessMain,
      );

      // Clear form
      regUsernameController.clear();
      regEmailController.clear();
      regPasswordController.clear();
      regConfirmPasswordController.clear();
      agreeToTerms.value = false;

      Get.offNamed(Routes.LOGIN);
    } on ApiException catch (e) {
      print('❌ Register failed: ${e.message}');
      _showSnack('Error', e.message, app.appErrorMain);
    } catch (e) {
      print('❌ Register unexpected error: $e');
      _showSnack('Error', 'Terjadi kesalahan tidak terduga', app.appErrorMain);
    } finally {
      isLoading.value = false;
    }
    print('📝 ======================================');
  }

  // LOGOUT
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      _showSnack('Info', 'Anda telah logout', app.appInfoDark);
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('❌ Logout error: $e. Forcing logout anyway.');
      _showSnack('Info', 'Anda telah logout', app.appInfoDark);
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helper methods ---

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