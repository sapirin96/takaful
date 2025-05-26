import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takaful/app/modules/agency/controllers/agency_controller.dart';
import 'package:takaful/app/modules/claim/controllers/claim_controller.dart';
import 'package:takaful/app/modules/claim/views/claim_view.dart';
import 'package:takaful/app/modules/member/views/member_view.dart';
import 'package:takaful/app/modules/subscription/controllers/subscription_controller.dart';
import 'package:takaful/app/modules/subscription/views/subscription_view.dart';

import '../../agency/views/agency_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../member/controllers/member_controller.dart';

class MainController extends GetxController {
  final index = 0.obs;

  Widget getBody() {
    switch (Get.find<MainController>().index.value) {
      case 0:
        Get.lazyPut<HomeController>(() => HomeController());
        return const HomeView();
      case 1:
        Get.lazyPut<MemberController>(() => MemberController());
        return const MemberView();
      case 2:
        Get.lazyPut<SubscriptionController>(() => SubscriptionController());
        return const SubscriptionView();
      case 3:
        Get.lazyPut<ClaimController>(() => ClaimController());
        return const ClaimView();
      case 4:
        Get.lazyPut<AgencyController>(() => AgencyController());
        return const AgencyView();
      default:
        Get.lazyPut<HomeController>(() => HomeController());
        return const HomeView();
    }
  }
}
