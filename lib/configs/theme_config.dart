import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/services/setting_service.dart';
import 'color_config.dart';

class ThemeConfig {
  static SettingService setting = Get.find<SettingService>();

  static ThemeData darkTheme(context) {
    double fontChange = getFontChange();

    final textTheme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
          fontSizeFactor: 1.0 * fontChange,
          fontSizeDelta: 0 * fontChange,
        );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      textTheme: Locale(setting.defaultLocale.value) == const Locale('km_KH')
          ? GoogleFonts.battambangTextTheme(textTheme)
          : GoogleFonts.poppinsTextTheme(textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: ColorConfig.blue,
      ),
    );
  }

  static ThemeData lightTheme(context) {
    double fontChange = getFontChange();

    final textTheme = Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.0 * fontChange,
          fontSizeDelta: 0 * fontChange,
        );

    return ThemeData(
      textTheme: setting.defaultLocale.value == 'km_KH'
          ? GoogleFonts.suwannaphumTextTheme(textTheme)
          : GoogleFonts.poppinsTextTheme(textTheme),
      primarySwatch: ColorConfig.blue,
      scaffoldBackgroundColor: Colors.grey.shade100,
      primaryColor: ColorConfig.gold,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: ColorConfig.blue,
        titleTextStyle: setting.defaultLocale.value == 'km_KH'
            ? GoogleFonts.suwannaphumTextTheme(textTheme).titleLarge?.copyWith(
                  color: Colors.white,
                )
            : GoogleFonts.poppinsTextTheme(textTheme).titleLarge?.copyWith(
                  color: Colors.white,
                ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ColorConfig.blue,
        textTheme: ButtonTextTheme.normal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static double getFontChange() {
    switch (Get.find<SettingService>().fontSize.value) {
      case FontSize.small:
        return 0.8;
      case FontSize.medium:
        return 1;
      case FontSize.large:
        return 1.2;
      default:
        return 1;
    }
  }

  static double borderRadius = 0;
}
