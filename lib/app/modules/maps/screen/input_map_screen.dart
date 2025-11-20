import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_rt/app/widgets/button/custom_button_field.dart';
import 'package:smart_rt/app/widgets/drop_down/costum_drop_down.dart';
import 'package:smart_rt/app/widgets/text_field/custom_text_field.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../routes/app_pages.dart';
import '../controllers/maps_controller.dart';

class InputMapView extends GetView<MapsController> {
  const InputMapView({super.key});

  @override
  //Header
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: app.appBackgroundMain.withValues(alpha: 0),
      body: Stack(
        children: [
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
                    const SizedBox(height: 8),
                    const Text(
                      'Masukkan alamat anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: app.appTextDark
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown(
                      hint: 'Provinsi, Kabupaten, Kecamatan, Desa',
                      value: controller.provinceDistrictController.text.isEmpty
                          ? null
                          : controller.provinceDistrictController.text,
                      items: const [
                        'Jawa Timur, Malang, Lowokwaru, Tulusrejo',
                        'DKI Jakarta, Jakarta Selatan, Kebayoran Baru',
                        'Jawa Barat, Bandung, Coblong, Dago',
                      ],
                      onChanged: (val) {
                        controller.provinceDistrictController.text = val ?? '';
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Nama jalan, Gedung, No.rumah',
                      controller: controller.streetController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Detail lainnya (Blok, ,No. Unit/Gang)',
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
                      'Atur titik rumah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: app.appTextDark
                      ),
                    ),
                    const SizedBox(height: 8),
                    _MapPreview(controller: controller),
                    const SizedBox(height: 24),
                    Obx(() {
                      final enabled = controller.canSubmit.value;
                      return CustomButton(
                        text: 'Kirim',
                        enabled: enabled,
                        backgroundColor: enabled
                            ? app.appPrimaryMain
                            : app.appNeutralMain,
                        onPressed: enabled
                            ? () async {
                                await Get.offAllNamed(
                                  Routes.HOME,
                                  arguments: {'showSuccessPopup': true},
                                );
                              }
                            : null,
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

class _MapPreview extends StatefulWidget {
  const _MapPreview({required this.controller});
  final MapsController controller;

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
              onTap: () async {
                // Jika pertama kali (belum ada lokasi dipilih), request permission dulu
                if (widget.controller.selectedLatitude.value == null ||
                    widget.controller.selectedLongitude.value == null) {
                  // Request permission dengan popup
                  final permissionGranted = await widget.controller
                      .requestLocationPermission();
                  if (!permissionGranted) {
                    // Jika permission ditolak, tidak buka SelectMap
                    return;
                  }
                }

                // Buka SelectMap
                final result = await Get.toNamed(
                  Routes.SELECT_MAP,
                  arguments: {
                    if (widget.controller.selectedLatitude.value != null &&
                        widget.controller.selectedLongitude.value != null)
                      'lat': widget.controller.selectedLatitude.value,
                    if (widget.controller.selectedLatitude.value != null &&
                        widget.controller.selectedLongitude.value != null)
                      'lng': widget.controller.selectedLongitude.value,
                  },
                );
                if (result is Map) {
                  final lat = result['lat'] as double?;
                  final lng = result['lng'] as double?;
                  if (lat != null && lng != null) {
                    widget.controller.setSelectedLocation(
                      lat: lat,
                      lng: lng,
                      address: result['address'] as String?,
                    );
                  }
                }
              },
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
      // Always show live map; if no selection, center to default city
      RepaintBoundary(
        child: FlutterMap(
          mapController: widget.controller.mapController,
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
              errorTileCallback: (tile, error, stackTrace) {
                // Silently ignore abort errors
              },
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
      // Coordinates overlay when selected
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
