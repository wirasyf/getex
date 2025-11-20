import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../../../widgets/text_field/custom_text_field.dart';
// SINKRONISASI: Ganti controller
import '../controllers/input_map_controller.dart';

// SINKRONISASI: Ganti GetView
class InputMapView extends GetView<InputMapController> {
  const InputMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: app.appBackgroundMain.withValues(alpha: 0),
      body: Stack(
        children: [
          // ... (Header tidak berubah) ...
          Positioned.fill(child: Container(color: app.appInfoHover)),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/shapes/wave.png',
              width: size.width * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tambahkan Alamat',
                  style: TextStyle(
                    color: app.appTextSecond,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    'assets/ilustration/map.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          // Form panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... (Semua CustomTextField tidak berubah) ...
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan alamat anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Provinsi',
                      controller: controller.provinceController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Kabupaten/Kota',
                      controller: controller.districtController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Kecamatan',
                      controller: controller.subDistrictController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Desa/Kelurahan',
                      controller: controller.villageController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Nama jalan, Gedung, No.rumah',
                      controller: controller.streetController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Detail lainnya (Blok, No. Unit, Gang)',
                      controller: controller.additionalDetailController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'RT (Tidak wajib)',
                      controller: controller.rtController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'RW (Tidak wajib)',
                      controller: controller.rwController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Atur titik rumah (Wajib)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MapPreview(controller: controller),
                    const SizedBox(height: 24),
                    Obx(() {
                      final bool canSubmit = controller.canSubmit.value;
                      final bool isLoading = controller.isLoading.value;
                      final bool enabled = canSubmit && !isLoading;

                      return CustomButton(
                        text: isLoading ? 'Loading...' : 'Kirim',
                        enabled: enabled,
                        backgroundColor: enabled
                            ? app.appPrimaryMain
                            : app.appNeutralMain,
                        // SINKRONISASI: Memanggil submitAddress
                        onPressed: enabled ? controller.submitAddress : null,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET PREVIEW PETA ---
class _MapPreview extends StatefulWidget {
  const _MapPreview({required this.controller});
  // SINKRONISASI: Ganti controller
  final InputMapController controller;

  @override
  State<_MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<_MapPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      final hasSelection =
          widget.controller.selectedLatitude.value != null &&
          widget.controller.selectedLongitude.value != null;

      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: _buildLiveMap(hasSelection),
            ),
          ),
          Positioned.fill(
            child: InkWell(
              // SINKRONISASI: Panggil openMapPicker
              onTap: widget.controller.openMapPicker,
              child: Center(
                child: hasSelection
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: app.appBackgroundMain.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit, color: app.appTextDark),
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLiveMap(bool hasSelection) => Stack(
    children: [
      RepaintBoundary(
        child: FlutterMap(
          // SINKRONISASI: Gunakan mapPreviewController
          mapController: widget.controller.mapPreviewController,
          options: MapOptions(
            initialCenter: hasSelection
                ? LatLng(
                    widget.controller.selectedLatitude.value!,
                    widget.controller.selectedLongitude.value!,
                  )
                : const LatLng(-7.981894, 112.626503), // default (Malang)
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'smart_rt',
              keepBuffer: 2,
              maxNativeZoom: 18,
              maxZoom: 18,
              tileDimension: 256,
              retinaMode: false,
              errorTileCallback: (tile, error, stackTrace) {},
            ),
            if (hasSelection)
              MarkerLayer(
                rotate: true,
                markers: [
                  Marker(
                    point: LatLng(
                      widget.controller.selectedLatitude.value!,
                      widget.controller.selectedLongitude.value!,
                    ),
                    width: 32,
                    height: 32,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on,
                      color: app.appErrorMain,
                      size: 32,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      if (hasSelection)
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: app.appBackgroundMain.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${widget.controller.selectedLatitude.value!.toStringAsFixed(4)}, ${widget.controller.selectedLongitude.value!.toStringAsFixed(4)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
