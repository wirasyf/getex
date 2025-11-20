import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_bindings.dart';
import 'app/data/service/storage_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
      title: 'Smart RT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialBinding: InitialBinding(),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
}
