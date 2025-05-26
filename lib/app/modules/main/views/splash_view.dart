import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:takaful/app/services/setting_service.dart';

import '../../../../configs/color_config.dart';
import '../../../services/auth_service.dart';
import '../controllers/main_controller.dart';
import 'main_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  String _status = 'Loading...'.tr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConfig.blue,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: AnimatedSplashScreen.withScreenFunction(
        splash: Column(
          children: [
            const Image(
              image: AssetImage('lib/assets/images/logo.png'),
              height: 150,
              width: 150,
            ),

            /// Loading indicator
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        splashIconSize: 300,
        screenFunction: () async {
          /// Check authentication
          setState(() {
            _status = 'Checking authentication status...'.tr;
          });

          final auth = Get.find<AuthService>();

          /// Check if user is logged in
          if (auth.token.value != null) {
            await auth.getUser();

            if (auth.authenticated.value) {
              Get.lazyPut<MainController>(() => MainController());
              Get.find<SettingService>().checkMember();
              return const MainView();
            }
          }

          Get.lazyPut<MainController>(() => MainController());
          return const MainView();
        },
        centered: true,
        backgroundColor: ColorConfig.blue,
        splashTransition: SplashTransition.fadeTransition,
        curve: Curves.easeInCirc,
      ),
    );
  }
}
