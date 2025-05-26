import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'app/locales/translation.dart';
import 'app/modules/main/views/splash_view.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/notification_service.dart';
import 'app/services/setting_service.dart';
import 'configs/theme_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => SettingService().init());
  await Get.putAsync(() => NotificationService().init());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingService setting = Get.find<SettingService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Takaful Cambodia",
      builder: (context, child) {
        return FlutterEasyLoading(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.translucent,
            child: child,
          ),
        );
      },
      theme: ThemeConfig.lightTheme(context),
      darkTheme: ThemeConfig.darkTheme(context),
      themeMode: ThemeMode.light,
      home: const SplashView(),
      getPages: AppPages.routes,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: Locale(setting.defaultLocale.value),
      fallbackLocale: const Locale('en_US'),
    );
  }
}
