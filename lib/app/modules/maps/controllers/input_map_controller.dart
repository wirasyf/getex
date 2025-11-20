// app/modules/maps/controllers/input_map_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';
import 'package:smart_rt/app/routes/app_pages.dart';
import 'package:smart_rt/app/data/repository/profile_repository.dart';
import 'package:smart_rt/app/data/models/maps.dart';
import '../../../core/constant/colors/colors.dart' as app;

// SINKRONISASI: Controller terpisah untuk Input Peta
class InputMapController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();

  // Controllers Form
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final subDistrictController = TextEditingController();
  final villageController = TextEditingController();
  final streetController = TextEditingController();
  final additionalDetailController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();

  // State Peta
  final selectedLatitude = RxnDouble();
  final selectedLongitude = RxnDouble();
  final MapController mapPreviewController = MapController();

  // State UI
  final canSubmit = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Tambahkan listener untuk validasi
    provinceController.addListener(_recomputeSubmit);
    districtController.addListener(_recomputeSubmit);
    subDistrictController.addListener(_recomputeSubmit);
    villageController.addListener(_recomputeSubmit);
    streetController.addListener(_recomputeSubmit);
  }

  /// Membuka halaman pemilih peta
  Future<void> openMapPicker() async {
    // Request permission jika belum ada lokasi
    if (selectedLatitude.value == null) {
      final permissionGranted = await _requestLocationPermission();
      if (!permissionGranted) return;
    }

    // Kirim lat/lng saat ini ke SelectMapController
    final result = await Get.toNamed(
      Routes.SELECT_MAP,
      arguments: {
        'lat': selectedLatitude.value,
        'lng': selectedLongitude.value,
      },
    );

    // Tangkap hasil dari Get.back()
    if (result is Map) {
      final lat = result['lat'] as double?;
      final lng = result['lng'] as double?;
      if (lat != null && lng != null) {
        setSelectedLocation(lat: lat, lng: lng);
      }
    }
  }

  /// [ENDPOINT: /family/set-address]
  /// Menyimpan alamat baru
  Future<void> submitAddress() async {
    if (!canSubmit.value) {
      _showSnack('Error', 'Harap lengkapi semua data wajib', app.appErrorMain);
      return;
    }
    isLoading.value = true;
    try {
      final addressData = AddressModel(
        province: provinceController.text,
        district: districtController.text,
        subDistrict: subDistrictController.text,
        village: villageController.text,
        address: streetController.text,
        addressDetail: additionalDetailController.text.isNotEmpty
            ? additionalDetailController.text
            : null,
        rt: rtController.text.isNotEmpty ? rtController.text : null,
        rw: rwController.text.isNotEmpty ? rwController.text : null,
        latitude: selectedLatitude.value!,
        longitude: selectedLongitude.value!,
      );

      // Panggil endpoint SET (Create)
      await _profileRepository.setAddress(address: addressData);

      _showSnack(
        'Berhasil',
        'Alamat Anda berhasil disimpan',
        app.appSuccessMain,
      );
      // Navigasi ke Home
      await Get.offAllNamed(Routes.HOME, arguments: {'showSuccessPopup': true});
    } on ApiException catch (e) {
      _showSnack('Error', e.message, app.appErrorMain);
    } catch (e) {
      _showSnack(
        'Error',
        'Terjadi kesalahan tidak terduga: $e',
        app.appErrorMain,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helpers ---

  void setSelectedLocation({
    required double lat,
    required double lng,
    String? address,
  }) {
    selectedLatitude.value = lat;
    selectedLongitude.value = lng;
    try {
      mapPreviewController.move(LatLng(lat, lng), 15);
    } catch (_) {
      /* Abaikan jika map belum siap */
    }
    _recomputeSubmit();
  }

  void _recomputeSubmit() {
    canSubmit.value = _validateCanSubmit();
  }

  bool _validateCanSubmit() {
    final provinceValid = provinceController.text.isNotEmpty;
    final districtCityValid = districtController.text.isNotEmpty;
    final subDistrictValid = subDistrictController.text.isNotEmpty;
    final villageValid = villageController.text.isNotEmpty;
    final streetValid = streetController.text.isNotEmpty;
    final locationValid =
        selectedLatitude.value != null && selectedLongitude.value != null;
    return provinceValid &&
        districtCityValid &&
        subDistrictValid &&
        villageValid &&
        streetValid &&
        locationValid;
  }

  Future<bool> _requestLocationPermission() async {
    // ... (Logika request permission) ...
    try {
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final result = await Get.dialog<bool>(
          AlertDialog(
            content: const Text('Izinkan app untuk akses lokasi perangkat ini'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Tolak',
                  style: TextStyle(color: app.appTextDark),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Izinkan',
                  style: TextStyle(color: app.appTextDark),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        if (result == true) {
          await Geolocator.openLocationSettings();
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) return false;
        } else {
          return false;
        }
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final result = await Get.dialog<bool>(
          AlertDialog(
            content: const Text('Izinkan app untuk akses lokasi perangkat ini'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Tolak',
                  style: TextStyle(color: app.appTextDark),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Izinkan',
                  style: TextStyle(color: app.appTextDark),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        if (result == true) {
          permission = await Geolocator.requestPermission();
        } else {
          return false;
        }
        if (permission == LocationPermission.denied) return false;
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

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
    provinceController.dispose();
    districtController.dispose();
    subDistrictController.dispose();
    villageController.dispose();
    streetController.dispose();
    additionalDetailController.dispose();
    rtController.dispose();
    rwController.dispose();
    mapPreviewController.dispose();
    super.onClose();
  }
}
