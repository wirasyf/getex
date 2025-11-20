// ... import lainnya ...
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:smart_rt/app/bindings/initial_bindings.dart';
import 'package:smart_rt/app/data/service/storage_service.dart';
import 'package:smart_rt/app/routes/app_pages.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart RT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialBinding: InitialBinding(),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
