import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/routes/routes.dart';
import 'package:pet_care/services/fcm_service.dart';
import 'bindings/all_binding.dart';
import 'firebase_options.dart';
import 'routes/routes_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return GetMaterialApp(
      theme: ThemeData(
          cardColor: Colors.white,
          useMaterial3: true,
          cardTheme: const CardTheme(
            surfaceTintColor: Colors.white,
            elevation: 5
          ),
          backgroundColor: MyColors.backgroundApp,
          appBarTheme: const AppBarTheme(
            backgroundColor: MyColors.primaryColor,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            )
          )),
      initialBinding: AllBinding(),
      initialRoute: RoutesConst.splash,
      getPages: Routes.routes,
      debugShowCheckedModeBanner: false,
      title: 'Chuột Spa',
    );
  }
}
