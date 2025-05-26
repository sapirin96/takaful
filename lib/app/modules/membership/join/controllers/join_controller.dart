import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/membership/join/views/join_abapay_view.dart';
import 'package:takaful/app/modules/membership/join/views/join_khqr_view.dart';
import 'package:takaful/app/modules/membership/join/views/join_payway_view.dart';
import 'package:takaful/app/modules/membership/join/views/join_success_view.dart';
import 'package:takaful/app/services/setting_service.dart';

import '../../../../data/models/subscription_model.dart';
import '../../../../data/providers/verification_provider.dart';
import '../../../../services/api_service.dart';

class JoinController extends GetxController {
  final isLoading = RxBool(false);
  final subscription = Rxn<SubscriptionModel>();

  Future<void> checkout(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      switch (data['payment_method_code']) {
        case 'CARDS':
          {
            await Get.to(() => const JoinPayWayView());
            await checkTransaction();
            break;
          }

        case 'ABAPAY':
          {
            await Get.to(() => const JoinABAPayView());
            await checkTransaction();
            break;
          }

        case 'KHQR':
          {
            dynamic response = await ApiService.get('insurance/abapay/join?payment_method_code=abapay_khqr_deeplink');

            /// check is response is not null and an object
            if (response != null && response is Map<String, dynamic>) {
              /// check is response has data
              if (response['status'] != null && response['status']['code'] != null) {
                if (response['status']['code'] == "00") {
                  /// check if response has abapay_deeplink
                  if (response['abapay_deeplink'] != null && response['checkout_qr_url'] != null) {
                    /// check if can launch url
                    await Get.to(() => JoinKHQRView(
                          checkoutUrl: response['checkout_qr_url'],
                          deepLink: response['abapay_deeplink'],
                        ));
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
            await Get.to(() => const JoinPayWayView());
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
      isLoading.value = true;

      /// wait for 3 seconds
      await Future.delayed(const Duration(seconds: 3));

      bool isMemberResult = await VerificationProvider.isMember() ?? false;
      Get.find<SettingService>().isMember.value = isMemberResult;
      if (isMemberResult == true) {
        Get.off(() => const JoinSuccessView());
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
}
