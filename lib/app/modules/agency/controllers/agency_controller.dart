import 'package:get/get.dart';

import '../../../data/providers/agency_provider.dart';

class AgencyController extends GetxController {
  Future<void> delete(String uuid) async {
    await AgencyProvider.delete(uuid);
  }
}
