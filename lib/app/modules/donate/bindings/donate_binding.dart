import 'package:get/get.dart';

import '../controllers/donate_controller.dart';

class DonateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonateController>(
      () => DonateController(),
    );
  }
}
