import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/primary_button_component.dart';
import '../../../../data/models/subscription_model.dart';
import '../../../../routes/app_pages.dart';

class RenewSuccessView extends StatefulWidget {
  final SubscriptionModel subscription;

  const RenewSuccessView({super.key, required this.subscription});

  @override
  State<RenewSuccessView> createState() => _RenewSuccessViewState();
}

class _RenewSuccessViewState extends State<RenewSuccessView> {
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
                'Renew Membership Success'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Thank you for renewing your membership'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Start Date'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "${widget.subscription.formattedStartDate}",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'End Date'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "${widget.subscription.formattedEndDate}",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Amount'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "\$25.00/${'Year'.tr}",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Payment Method'.tr,
              //   style: Get.textTheme.bodyMedium,
              // ),
              // Text(
              //   "${widget.subscription.paymentMethod}",
              //   style: Get.textTheme.titleLarge?.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
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
              child: Text(
                'Return Back'.tr,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
