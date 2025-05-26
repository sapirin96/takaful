import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/primary_button_component.dart';
import '../../../../routes/app_pages.dart';

class JoinSuccessView extends StatefulWidget {
  const JoinSuccessView({super.key});

  @override
  State<JoinSuccessView> createState() => _JoinSuccessViewState();
}

class _JoinSuccessViewState extends State<JoinSuccessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),
              Text(
                'Join Membership Success'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Thank you for your membership'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              // const SizedBox(height: 20),
              // Text(
              //   'Start Date'.tr,
              //   style: Get.textTheme.bodyMedium,
              // ),
              // Text(
              //   "01st April 2023",
              //   style: Get.textTheme.titleLarge?.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // Text(
              //   'End Date'.tr,
              //   style: Get.textTheme.bodyMedium,
              // ),
              // Text(
              //   "31st March 2024",
              //   style: Get.textTheme.titleLarge?.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 20),
              Text(
                'Amount'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text("\$25.00/${'Year'.tr}",
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Text(
                'Payment Method'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "Credit Card",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
        width: Get.width,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: PrimaryButtonComponent(
              onPressed: () {
                Get.offAllNamed(Routes.MAIN);
              },
              child: Text('Return Back'.tr),
            ),
          ),
        ),
      ),
    );
  }
}
