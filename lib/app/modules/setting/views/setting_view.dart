import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/services/setting_service.dart';

import '../../../services/notification_service.dart';
import 'account_deactivation_view.dart';
import 'language_view.dart';

class SettingView extends GetView<SettingService> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'.tr),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.notifications,
                ),
              ),
              title: Text('Notifications'.tr),
              subtitle:
                  Text('Turn on notifications to get the latest updates.'.tr),
              trailing: GetX<NotificationService>(
                builder: (notification) {
                  return Switch.adaptive(
                    value: notification.status.value ==
                        AuthorizationStatus.authorized,
                    onChanged: (value) async {
                      if (value) {
                        await notification.enableNotification();
                      } else {
                        await notification.disableNotification();
                      }
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.font_download_outlined),
              ),
              title: Text('Font Size'.tr),
              subtitle: Text(
                  'Change the font size of the application to your liking. App relaunch is required.'
                      .tr),
              onTap: () {
                Get.bottomSheet(
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.6,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        title: Text('Font Size'.tr),
                        centerTitle: false,
                      ),
                      body: ListView(
                        children: [
                          ListTile(
                            leading: Obx(
                              () => Radio<FontSize>(
                                value: FontSize.small,
                                groupValue: controller.fontSize.value,
                                onChanged: (value) async {
                                  await controller.setFontSize(value!);
                                },
                              ),
                            ),
                            title: Text(
                              'Small'.tr,
                              style: Get.textTheme.titleSmall,
                            ),
                            onTap: () async {
                              await controller.setFontSize(FontSize.small);
                            },
                          ),
                          ListTile(
                            leading: Obx(
                              () => Radio<FontSize>(
                                value: FontSize.medium,
                                groupValue: controller.fontSize.value,
                                onChanged: (value) async {
                                  await controller.setFontSize(value!);
                                },
                              ),
                            ),
                            title: Text(
                              'Medium'.tr,
                              style: Get.textTheme.titleMedium,
                            ),
                            onTap: () async {
                              await controller.setFontSize(FontSize.medium);
                            },
                          ),
                          ListTile(
                            leading: Obx(
                              () => Radio<FontSize>(
                                value: FontSize.large,
                                groupValue: controller.fontSize.value,
                                onChanged: (value) async {
                                  await controller.setFontSize(value!);
                                },
                              ),
                            ),
                            title: Text(
                              'Large'.tr,
                              style: Get.textTheme.titleLarge,
                            ),
                            onTap: () async {
                              await controller.setFontSize(FontSize.large);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.dark_mode),
              ),
              title: Text('Theme Mode'.tr),
              subtitle:
                  Text('Change the theme of the application to your liking'.tr),
              onTap: () {
                Get.bottomSheet(
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.6,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        title: Text('Theme Mode'.tr),
                        centerTitle: false,
                      ),
                      body: ListView(
                        children: [
                          ListTile(
                            leading: Obx(
                              () => Radio<ThemeMode>(
                                value: ThemeMode.light,
                                groupValue: controller.themeMode.value,
                                onChanged: (value) async {
                                  await controller.setThemeMode(value!);
                                },
                              ),
                            ),
                            title: Text('Light Mode'.tr),
                            onTap: () async {
                              await controller.setThemeMode(ThemeMode.light);
                            },
                          ),
                          ListTile(
                            leading: Obx(
                              () => Radio<ThemeMode>(
                                value: ThemeMode.dark,
                                groupValue: controller.themeMode.value,
                                onChanged: (value) async {
                                  await controller.setThemeMode(value!);
                                },
                              ),
                            ),
                            title: Text('Dark Mode'.tr),
                            onTap: () async {
                              await controller.setThemeMode(ThemeMode.dark);
                            },
                          ),
                          ListTile(
                            leading: Obx(
                              () => Radio<ThemeMode>(
                                value: ThemeMode.system,
                                groupValue: controller.themeMode.value,
                                onChanged: (value) async {
                                  await controller.setThemeMode(value!);
                                },
                              ),
                            ),
                            title: Text('System Mode'.tr),
                            onTap: () async {
                              await controller.setThemeMode(ThemeMode.system);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(
                  Icons.language,
                ),
              ),
              title: Text('Language'.tr),
              subtitle: Text('Change the language of the app'.tr),
              onTap: () {
                Get.to(() => const LanguageView());
              },
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.no_accounts_sharp,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Account Deletion'.tr,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              subtitle: Text(
                'Delete your account from our system'.tr,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              trailing: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {
                Get.to(() => const AccountDeactivationView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
