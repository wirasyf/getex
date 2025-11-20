import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/service/dio_service.dart';

const String baseUrl = "http://localhost:8000";

ImageProvider? loadLaravelImage(String? path) {
  if (path == null || path.isEmpty) return null;

  // Jika path sudah URL lengkap
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }

  // Jika file dari public/storage
  return NetworkImage("$baseUrl/storage/$path");
}
Future<Image> loadPrivateLaravelImage(String filename) async {
  try {
    final dioService = Get.find<DioService>();
    
    // Tambahkan prefix 'private/' otomatis
    final fullPath = '$filename';
    
    print('🔍 Loading: $fullPath');
    
    final response = await dioService.dio.get(
      "/storage/private/$fullPath",
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = Uint8List.fromList(response.data);
    print('✅ Image loaded successfully');
    return Image.memory(bytes, fit: BoxFit.cover);
  } catch (e) {
    print('❌ Error loading private image: $e');
    return Image.asset('assets/image/selokan.png', fit: BoxFit.cover);
  }
}
