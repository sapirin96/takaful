import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/providers/verification_provider.dart';
import 'package:takaful/app/services/auth_service.dart';

import '../../utils/catcher_util.dart';
import '../../utils/storage_util.dart';

enum FontSize { small, medium, large }

class SettingService extends GetxService {
  final defaultLocale = RxString('km_KH');
  final isMember = RxBool(false);
  final isProfileCompleted = RxBool(false);

  final themeMode = Rx<ThemeMode>(ThemeMode.system);
  final fontSize = Rx<FontSize>(FontSize.medium);

  Future<SettingService> init() async {
    await getLocale();
    return this;
  }

  Future getLocale() async {
    defaultLocale.value = await StorageUtil.securedRead('locale') ?? 'km_KH';
  }

  void switchLocale(String locale) async {
    defaultLocale.value = locale;
    Get.updateLocale(Locale(locale));
    await StorageUtil.securedWrite('locale', locale);
  }

  /// Check if member is completed profile
  Future<void> checkMember() async {
    if (Get.find<AuthService>().user.value?.tokenableType?.toLowerCase() ==
        'member') {
      bool isMemberResult = await VerificationProvider.isMember() ?? false;
      bool isProfileCompletedResult =
          await VerificationProvider.isProfileCompleted() ?? false;
      isMember.value = isMemberResult;
      isProfileCompleted.value = isProfileCompletedResult;
    }
  }

  getThemeMode() async {
    String? mode = await StorageUtil.securedRead('themeMode');

    switch (mode) {
      case 'ThemeMode.system':
        themeMode.value = ThemeMode.system;
        break;
      case 'ThemeMode.light':
        themeMode.value = ThemeMode.light;
        break;
      case 'ThemeMode.dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }
  }

  setThemeMode(ThemeMode mode) async {
    try {
      themeMode.value = mode;
      await StorageUtil.securedWrite('themeMode', mode.toString());
      Get.changeThemeMode(mode);
      Get.back(result: true);
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }

  getFontSize() async {
    String? size = await StorageUtil.securedRead('fontSize');

    switch (size) {
      case 'FontSize.small':
        fontSize.value = FontSize.small;
        break;
      case 'FontSize.medium':
        fontSize.value = FontSize.medium;
        break;
      case 'FontSize.large':
        fontSize.value = FontSize.large;
        break;
      default:
        fontSize.value = FontSize.medium;
    }
  }

  setFontSize(FontSize size) async {
    try {
      fontSize.value = size;

      await StorageUtil.securedWrite('fontSize', size.toString());

      Get.back(result: true);

      Get.rawSnackbar(
          message: "Please restart the app to apply the changes".tr);
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }
}
