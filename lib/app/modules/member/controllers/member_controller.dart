import 'package:get/get.dart';

import '../../../data/providers/member_provider.dart';

class MemberController extends GetxController {
  Future<void> delete(String uuid) async {
    await MemberProvider.delete(uuid);
  }
}
