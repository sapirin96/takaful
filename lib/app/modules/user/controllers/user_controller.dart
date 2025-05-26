import 'package:get/get.dart';

import '../../../data/providers/admin/user_provider.dart';

class UserController extends GetxController {
  Future<void> delete(String uuid) async {
    await UserProvider.delete(uuid);
  }
}
