import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/splash/splash_controller.dart';
import 'package:pet_care/widgets/app_text.dart';

class SplashPage extends GetView<SplashController> {

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build ui');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'images/logo_rebg.png',
              width: 200,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppText(
            text: controller.name,
            color: MyColors.primaryColor,
            isBold: true,
            size: 25,
          )
        ],
      ),
    );
  }
}
