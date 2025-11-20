import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:smart_rt/app/widgets/button/custom_button_field.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../controllers/maps_controller.dart';

class SelectMapView extends GetView<MapsController> {
  const SelectMapView({super.key});
  @override
  Widget build(BuildContext context) {
    final mapController = MapController();

    // Init lokasi peta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeMapLocation();

      if (controller.selectedPosition.value != null) {
        mapController.move(controller.selectedPosition.value!, 15);
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.back();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Loading
            Obx(() {
              if (controller.isLoadingLocation.value) {
                return Container(
                  color: app.appTextDark.withValues(alpha: 0.54),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: app.appPrimaryMain),
                        SizedBox(height: 16),
                        Text(
                          'Mendapatkan lokasi Anda...',
                          style: TextStyle(
                            color: app.appTextSecond,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            //Map
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: controller.currentCenter,
                initialZoom: 15,
                onPositionChanged: (position, hasGesture) {
                  controller.selectedPosition.value = position.center;
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
                  errorTileCallback: (tile, error, stackTrace) {},
                ),
              ],
            ),
            // Indikator map
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Icon(
                      Icons.location_on,
                      color: app.appErrorMain,
                      size: 48,
                      shadows: [
                        Shadow(
                          color: app.appTextDark.withValues(alpha: 0.26),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: app.appBackgroundMain,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: app.appTextMain.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Obx(() {
                  final pos = controller.selectedPosition.value;
                  final hasPos = pos != null;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Atur titik rumah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: app.appTextDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: app.appInfoLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: app.appInfoDark,
                            ),
                            const SizedBox(width: 8),
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
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Atur titik alamat',
                        enabled: hasPos,
                        backgroundColor: hasPos
                            ? app.appPrimaryMain
                            : app.appNeutralMain,
                        onPressed: hasPos ? controller.confirm : null,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
