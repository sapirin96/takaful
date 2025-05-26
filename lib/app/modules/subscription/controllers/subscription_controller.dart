import 'package:get/get.dart';

import '../../../data/providers/subscription_provider.dart';

class SubscriptionController extends GetxController {
  Future<void> delete(String uuid) async {
    await SubscriptionProvider.delete(uuid);
  }
}
