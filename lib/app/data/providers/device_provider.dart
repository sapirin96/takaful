import 'package:get/instance_manager.dart';

import '../../../utils/catcher_util.dart';
import '../../../utils/device_util.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';

class DeviceProvider {
  static Future store() async {
    try {
      String udid = await DeviceUtil.getUdid();
      String? fcmToken = Get.find<NotificationService>().fcmToken.value;
      String os = await DeviceUtil.getOs();
      String osVersion = await DeviceUtil.getOsVersion();
      String manufacturer = await DeviceUtil.getManufacturer();
      String model = await DeviceUtil.getModel();
      String appVersion = await DeviceUtil.getAppVersion();

      await ApiService.post('devices', data: {
        "udid": udid,
        "fcm_token": "$fcmToken",
        "os": os,
        "os_version": osVersion,
        "manufacturer": manufacturer,
        "model": model,
        "app_version": appVersion,
      });
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }
}
