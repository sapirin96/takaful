import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:takaful/components/primary_button_component.dart';

import '../../../services/auth_service.dart';

class AccountDeactivationView extends StatefulWidget {
  const AccountDeactivationView({super.key});

  @override
  State<AccountDeactivationView> createState() => _AccountDeactivationViewState();
}

class _AccountDeactivationViewState extends State<AccountDeactivationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Deletion'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.warning,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 50),
            Text(
              'Delete Account'.tr,
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Once you delete your account, you will not be able to reactivate it.'.tr),
            const SizedBox(height: 50),
            PrimaryButtonComponent(
              onPressed: () async {
                try {
                  await Get.defaultDialog(
                    title: 'Delete Account'.tr,
                    content: Text('Are you sure you want to delete your account?'.tr),
                    textConfirm: 'Delete'.tr,
                    textCancel: 'Cancel'.tr,
                    confirmTextColor: Colors.white,
                    cancelTextColor: Colors.red,
                    buttonColor: Colors.red,
                    onConfirm: () async {
                      EasyLoading.show(status: 'Loading...'.tr);
                      await Get.find<AuthService>().deactivate();
                      Get.back();
                    },
                  );
                } finally {
                  EasyLoading.dismiss(animation: true);
                }
              },
              color: Colors.red,
              child: Text('Delete'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
