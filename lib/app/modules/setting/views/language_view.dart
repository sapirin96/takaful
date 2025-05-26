import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../configs/app_config.dart';
import '../../../locales/translation.dart';
import '../../../services/setting_service.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final SettingService setting = Get.find<SettingService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr),
        centerTitle: false,
        elevation: 1,
      ),
      body: Container(
        padding: AppConfig.containerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: Messages.languages.map((language) {
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Opacity(
                      opacity: setting.defaultLocale.value == language.code
                          ? 1
                          : 0.5,
                      child: SizedBox(
                        height: 60,
                        width: 70,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(language.assetUrl!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: setting.defaultLocale.value == language.code
                          ? 1
                          : 0.5,
                      child: Text(
                        language.name!,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setting.switchLocale(language.code!);
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
