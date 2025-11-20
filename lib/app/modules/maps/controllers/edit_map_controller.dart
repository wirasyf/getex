import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_rt/app/data/exceptions/api_exception.dart';
import 'package:smart_rt/app/routes/app_pages.dart'; // SINKRONISASI: Dihapus jika tidak terpakai, tapi sepertinya terpakai oleh openMapPicker
import 'package:smart_rt/app/modules/profile/controllers/profile_controller.dart';
import 'package:smart_rt/app/data/repository/profile_repository.dart';
import 'package:smart_rt/app/data/models/maps.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/pop_up/custom_popup_success.dart';

class EditMapController extends GetxController {
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();

  // ... (Controllers Form tidak berubah) ...
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final subDistrictController = TextEditingController();
  final villageController = TextEditingController();
  final streetController = TextEditingController();
  final additionalDetailController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();

  // ... (State Peta tidak berubah) ...
  final selectedLatitude = RxnDouble();
  final selectedLongitude = RxnDouble();
  final MapController mapPreviewController = MapController();

  // ... (State UI tidak berubah) ...
  final canSubmit = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // ... (Listeners tidak berubah) ...
    provinceController.addListener(_recomputeSubmit);
    districtController.addListener(_recomputeSubmit);
    subDistrictController.addListener(_recomputeSubmit);
    villageController.addListener(_recomputeSubmit);
    streetController.addListener(_recomputeSubmit);

    final address = Get.arguments as AddressModel?;
    if (address != null) {
      loadAddressData(address);
    }
  }

  /// Memuat data dari ProfileController ke form
  void loadAddressData(AddressModel address) {
    provinceController.text = address.province;
    districtController.text = address.district;
    subDistrictController.text = address.subDistrict;
    villageController.text = address.village;
    streetController.text = address.address;
    additionalDetailController.text = address.addressDetail ?? '';
    rtController.text = address.rt ?? '';
    rwController.text = address.rw ?? '';
    setSelectedLocation(lat: address.latitude, lng: address.longitude);
  }

  /// Membuka halaman pemilih peta
  Future<void> openMapPicker() async {
    if (selectedLatitude.value == null) {
      // SINKRONISASI: Panggil requestLocationPermission (dihilangkan '_')
      final permissionGranted = await requestLocationPermission();
      if (!permissionGranted) return;
    }

    final result = await Get.toNamed(
      Routes.SELECT_MAP,
      arguments: {
        'lat': selectedLatitude.value,
        'lng': selectedLongitude.value,
      },
    );

    if (result is Map) {
      final lat = result['lat'] as double?;
      final lng = result['lng'] as double?;
      if (lat != null && lng != null) {
        setSelectedLocation(lat: lat, lng: lng);
      }
    }
  }

  /// [ENDPOINT: /family/update-address]
  /// Menyimpan perubahan alamat
  // SINKRONISASI: Hapus parameter 'isUpdate'
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

      // Panggil endpoint UPDATE
      await _profileRepository.updateAddress(address: addressData);

      // Tampilkan Popup Sukses
      await CustomPopup.show(
        Get.context!,
        title: 'Alamat Diperbarui!',
        subtitle: 'Alamat Anda berhasil diperbarui.',
        type: PopupType.info,
        lottieAsset: 'assets/lottie/success.json',
        onClose: () {
          Get.back(); // Tutup popup DAN kembali ke ProfileView
          Get.find<ProfileController>().fetchProfile(); // Refresh data profile
        },
      );
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

  // SINKRONISASI: Hapus '_' agar bisa dipanggil dari view
  Future<bool> requestLocationPermission() async {
    // ... (Logika request permission tidak berubah) ...
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
