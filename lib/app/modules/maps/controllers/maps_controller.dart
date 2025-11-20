import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_rt/app/widgets/pop_up/permision_dialog.dart';

class MapsController extends GetxController {
  // Controllers
  final provinceDistrictController = TextEditingController();
  final streetController = TextEditingController();
  final additionalDetailController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();

  // Data lokasi terpilih
  final selectedLatitude = RxnDouble();
  final selectedLongitude = RxnDouble();
  final selectedAddress = ''.obs;

  final MapController mapController = MapController();
  final canSubmit = false.obs;

  // Map selection states
  final Rx<LatLng> initialPosition = const LatLng(-7.981894, 112.626503).obs;
  final selectedPosition = Rxn<LatLng>();
  final isLoadingLocation = false.obs;

  // Handle tap map
  // ignore: use_setters_to_change_properties
  void onMapTap(LatLng pos) {
    selectedPosition.value = pos;
  }

  // Konfirmasi lokasi
  void confirm() {
    final pos = selectedPosition.value;
    if (pos != null) {
      Get.back(
        result: {
          'lat': pos.latitude,
          'lng': pos.longitude,
          // 'address': 'Selected location', // optionally add via geocoding
        },
      );
    } else {
      Get.back();
    }
  }

  LatLng get currentCenter => selectedPosition.value ?? initialPosition.value;

  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      // Cek apakah layanan lokasi aktif
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final result = await PermissionDialog.show(
          content: 'Izinkan app untuk akses lokasi perangkat ini',
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

      // Jika izin ditolak
      if (permission == LocationPermission.denied) {
        final result = await PermissionDialog.show(
          content: 'Izinkan app untuk akses lokasi perangkat ini',
        );

        if (result == true) {
          permission = await Geolocator.requestPermission();
        } else {
          return false;
        }

        if (permission == LocationPermission.denied) return false;
      }

      // Jika izin ditolak secara permanen
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current location GPS
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);
      initialPosition.value = currentLatLng;
      selectedPosition.value = currentLatLng;

      isLoadingLocation.value = false;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      isLoadingLocation.value = false;
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ignore: prefer_expression_function_bodies
  bool _validateCanSubmit() {
    // Enable submit only when location is selected
    return selectedLatitude.value != null && selectedLongitude.value != null;
  }

  void setSelectedLocation({
    required double lat,
    required double lng,
    String? address,
  }) {
    selectedLatitude.value = lat;
    selectedLongitude.value = lng;
    if (address != null) {
      selectedAddress.value = address;
    }
    try {
      mapController.move(LatLng(lat, lng), 15);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}
    _recomputeSubmit();
  }

  void _recomputeSubmit() {
    canSubmit.value = _validateCanSubmit();
  }

  @override
  void onInit() {
    super.onInit();
    provinceDistrictController.addListener(_recomputeSubmit);
    streetController.addListener(_recomputeSubmit);

    final args = Get.arguments;
    if (args is Map) {
      final lat = args['lat'] as double?;
      final lng = args['lng'] as double?;
      if (lat != null && lng != null) {
        selectedPosition.value = LatLng(lat, lng);
      }
    }
  }

  // Init lokasi map
  void initializeMapLocation() {
    // Cek apakah sudah ada lokasi tersimpan
    if (selectedLatitude.value != null && selectedLongitude.value != null) {
      final savedLatLng = LatLng(
        selectedLatitude.value!,
        selectedLongitude.value!,
      );
      selectedPosition.value = savedLatLng;
      initialPosition.value = savedLatLng;
    } else {
      // Lakukan update lokasi tanpa blocking
      // ignore: unawaited_futures
      getCurrentLocation();
    }
  }

  @override
  void onClose() {
    provinceDistrictController.dispose();
    streetController.dispose();
    additionalDetailController.dispose();
    rtController.dispose();
    rwController.dispose();
    super.onClose();
  }
}
