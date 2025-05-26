import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:takaful/app/services/setting_service.dart';
import 'package:takaful/components/primary_button_component.dart';
import 'package:takaful/packages/conditional_builder.dart';

import '../../../routes/app_pages.dart';
import '../controllers/membership_controller.dart';

class MembershipView extends GetView<MembershipController> {
  const MembershipView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Policy'.tr),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              /// share asset pdf file
              await Share.share(
                'https://www.takafulcambodia.org/wp-content/uploads/2023/02/policy.pdf',
                subject: 'Membership Policy'.tr,
              );
            },
          ),
        ],
      ),
      body: PdfViewer.asset('lib/assets/pdf/policy.pdf'),

      /// add sign up button
      bottomNavigationBar: Obx(
        () => ConditionalBuilder(
          condition: Get.find<SettingService>().isMember.value == false,
          builder: (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: PrimaryButtonComponent(
                  onPressed: () {
                    Get.toNamed(Routes.JOIN);
                  },
                  child: Text(
                    'Join Membership'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          fallback: (_) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
