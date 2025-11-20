import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

// Pastikan path import ini sesuai dengan struktur proyek Anda
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/custom_button_field.dart';
import '../controllers/select_map_controller.dart';

class SelectMapView
    extends
        GetView<
          SelectMapController
        > {
  const SelectMapView({
    super.key,
  });
  @override
  Widget
  build(
    BuildContext context,
  ) => PopScope(
    onPopInvokedWithResult:
        (
          didPop,
          result,
        ) {
          if (!didPop) {
            Get.back();
          }
        },
    child: Scaffold(
      body: Stack(
        children: [
          //Map
          Obx(
            () => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.initialPosition.value,
                initialZoom: 16,
                onPositionChanged:
                    (
                      position,
                      hasGesture,
                    ) {
                      if (hasGesture) {
                        controller.onMapPositionChanged(
                          position.center,
                        );
                      }
                    },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'smart_rt',
                  retinaMode: false,
                  keepBuffer: 1,
                  tileDimension: 256,
                  panBuffer: 0,
                  tileDisplay: const TileDisplay.instantaneous(),
                  errorTileCallback:
                      (
                        tile,
                        error,
                        stackTrace,
                      ) {},
                ),
              ],
            ),
          ),
          // Indikator map (Pin di tengah)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.translate(
                  offset: const Offset(
                    0,
                    -20,
                  ), // Angkat pin sedikit
                  child: Icon(
                    Icons.location_on,
                    color: app.appErrorMain,
                    size: 48,
                    shadows: [
                      Shadow(
                        color: app.appTextDark.withValues(
                          alpha: 0.26,
                        ),
                        blurRadius: 4,
                        offset: const Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tombol Kembali (Back Button)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: CircleAvatar(
                backgroundColor: app.appBackgroundMain,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: Get.back,
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(
                    20,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: app.appTextMain.withValues(
                      alpha: 0.12,
                    ),
                    blurRadius: 10,
                    offset: const Offset(
                      0,
                      -2,
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24,
              ),
              child: Obx(
                () {
                  // SINKRONISASI: Gunakan state SelectMap
                  final pos = controller.selectedPosition.value;
                  final hasPos =
                      pos !=
                      null;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Atur titik rumah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.appInfoLight,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        padding: const EdgeInsets.all(
                          12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: app.appInfoDark,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                hasPos
                                    ? 'Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}'
                                    : 'Geser peta untuk mengatur lokasi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomButton(
                        text: 'Atur titik alamat',
                        enabled: hasPos,
                        backgroundColor: hasPos
                            ? app.appPrimaryMain
                            : app.appNeutralMain,
                        // SINKRONISASI: Panggil confirm
                        onPressed: hasPos
                            ? controller.confirm
                            : null,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Tombol "Lokasi Saya"
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                // *** INI ADALAH PERUBAHANNYA ***
                // Kita beri padding bawah agar tombolnya terangkat
                // di atas panel "Atur titik rumah".
                // Sesuaikan angka '190.0' jika kurang pas.
                padding: const EdgeInsets.only(
                  right: 10,
                  bottom: 200,
                ),
                child: Obx(
                  () => FloatingActionButton(
                    heroTag: 'gps_fab',
                    onPressed: controller.getCurrentLocation,
                    backgroundColor: app.appBackgroundMain,
                    child: controller.isLoadingLocation.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: app.appInfoDark,
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                            color: app.appInfoDark,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
