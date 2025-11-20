// app/modules/maps/controllers/select_map_controller.dart
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class SelectMapController extends GetxController {
  // State Peta
  final Rx<LatLng> initialPosition = const LatLng(
    -7.981894,
    112.626503,
  ).obs; // Default Malang
  final selectedPosition = Rxn<LatLng>();
  final isLoadingLocation = false.obs;
  late LatLng _originalPosition;
  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    initializeMapLocation();
  }

  /// Inisialisasi posisi peta
  void initializeMapLocation() {
    final args = Get.arguments;
    if (args is Map) {
      final lat = args['lat'] as double?;
      final lng = args['lng'] as double?;
      if (lat != null && lng != null) {
        final savedLatLng = LatLng(lat, lng);
        selectedPosition.value = savedLatLng;
        initialPosition.value = savedLatLng;
        _originalPosition = savedLatLng;
        return;
      }
    }

    getCurrentLocation();
  }

  /// Mengambil lokasi GPS saat ini
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
      _originalPosition = currentLatLng;
      mapController.move(currentLatLng, 16);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mendapatkan lokasi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Dipanggil saat peta di-tap/geser
  void onMapPositionChanged(LatLng? pos) {
    if (pos != null) {
      selectedPosition.value = pos;
    }
  }

  /// Getter untuk pusat peta
  LatLng get currentCenter => selectedPosition.value ?? initialPosition.value;

  /// Dipanggil saat tombol "Atur titik alamat" ditekan
  void confirm() {
    final pos = selectedPosition.value;
    if (pos != null) {
      // Kirim data LatLng kembali
      Get.back(result: {'lat': pos.latitude, 'lng': pos.longitude});
    } else {
      Get.back();
    }
  }

  /// Kembalikan pin ke lokasi GPS / awal
  void resetToCurrentLocation() {
    initialPosition.value = _originalPosition;
    selectedPosition.value = _originalPosition;
    mapController.move(_originalPosition, 16);
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}
