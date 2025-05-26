import 'package:get/get.dart';

import '../../../data/providers/zakat_provider.dart';

class ZakatController extends GetxController {
  Future<void> delete(String uuid) async {
    await ZakatProvider.delete(uuid);
  }
}
