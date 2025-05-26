import 'package:get/get.dart';

import '../../../data/providers/claim_provider.dart';

class ClaimController extends GetxController {
  Future<void> delete(String uuid) async {
    await ClaimProvider.delete(uuid);
  }
}
