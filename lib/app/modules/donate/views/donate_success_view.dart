import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/data/models/donation_model.dart';
import 'package:takaful/app/routes/app_pages.dart';
import 'package:takaful/components/primary_button_component.dart';

class DonateSuccessView extends StatefulWidget {
  final DonationModel donation;

  const DonateSuccessView({super.key, required this.donation});

  @override
  State<DonateSuccessView> createState() => _DonateSuccessViewState();
}

class _DonateSuccessViewState extends State<DonateSuccessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.MAIN),
          icon: const Icon(Icons.close),
        ),
        title: Text('Donate Success'.tr),
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
                'Donate Success'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Thank you for your donation'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Your donation will be used for'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "Charity",
                style: Get.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Amount'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "${widget.donation.formattedAmount}",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Date'.tr,
                style: Get.textTheme.bodyMedium,
              ),
              Text(
                "${widget.donation.formattedCreatedAt}",
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),

      /// add return button
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
