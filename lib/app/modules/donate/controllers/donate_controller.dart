import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/donate/views/donate_khqr_view.dart';
import 'package:takaful/app/services/api_service.dart';

import '../../../data/models/donation_model.dart';
import '../../../data/providers/donation_provider.dart';
import '../views/donate_abapay_view.dart';
import '../views/donate_payway_view.dart';
import '../views/donate_success_view.dart';

class DonateController extends GetxController {
  final isLoading = RxBool(false);
  final donation = Rxn<DonationModel>();

  Future<void> checkout(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      switch (data['payment_method_code']) {
        case 'CARDS':
          {
            await Get.to(() => DonatePayWayView(donation: donation.value!));
            await checkTransaction();
            break;
          }

        case 'ABAPAY':
          {
            await Get.to(() => DonateABAPayView(donation: donation.value!));
            await checkTransaction();
            break;
          }

        case 'KHQR':
          {
            dynamic response = await ApiService.get('insurance/abapay/donate?payment_method_code=abapay_khqr_deeplink&donation_uuid=${donation.value!.uuid}');

            /// check is response is not null and an object
            if (response != null && response is Map<String, dynamic>) {
              /// check is response has data
              if (response['status'] != null && response['status']['code'] != null) {
                if (response['status']['code'] == "00") {
                  /// check if response has abapay_deeplink
                  if (response['abapay_deeplink'] != null && response['checkout_qr_url'] != null) {
                    await Get.to(
                      () => DonateKHQRView(
                        donation: donation.value!,
                        checkoutUrl: response['checkout_qr_url'],
                        deepLink: response['abapay_deeplink'],
                      ),
                    );
                  } else {
                    Get.rawSnackbar(
                      title: 'Something went wrong'.tr,
                      message: 'Invalid response from server'.tr,
                    );
                  }
                } else {
                  Get.rawSnackbar(
                    title: 'Something went wrong'.tr,
                    message: response['status']['message'],
                  );
                }
              }
            }

            await checkTransaction();
            break;
          }

        default:
          {
            await Get.to(() => DonatePayWayView(donation: donation.value!));
            break;
          }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// check transaction
  Future<void> checkTransaction() async {
    try {
      if (donation.value == null) {
        return;
      }

      isLoading.value = true;

      /// wait for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      DonationModel? donationResult = await DonationProvider.show(donation.value!.uuid!);

      if (donationResult != null && donationResult.status == 'confirmed') {
        Get.off(() => DonateSuccessView(donation: donation.value!));
      } else {
        Get.rawSnackbar(
          title: 'Payment is incomplete'.tr,
          message: 'Look like this transaction is not yet completed, Please try again.'.tr,
          margin: const EdgeInsets.all(8),
          borderRadius: 16,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> delete(String uuid) async {
    await DonationProvider.delete(uuid);
  }
}
