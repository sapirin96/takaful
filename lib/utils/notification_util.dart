import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationUtil {
  static Future<void> onMessageHandler(RemoteMessage message) async {
    Get.rawSnackbar(
      title: "${message.notification!.title}",
      message: "${message.notification!.body}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 50),
      isDismissible: true,
    );
  }

  static Future<void> onMessageOpenedAppHandler(RemoteMessage message) async {
    if (message.data.containsKey('id')) {
      ////
    }
  }

  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    if (message.data.containsKey('id')) {
      ////
    }
  }
}
