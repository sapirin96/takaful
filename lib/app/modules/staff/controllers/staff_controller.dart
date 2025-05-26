import 'package:get/get.dart';

import '../../../data/providers/staff_provider.dart';

class StaffController extends GetxController {
  Future<void> delete(String uuid) async {
    await StaffProvider.delete(uuid);
  }
}
