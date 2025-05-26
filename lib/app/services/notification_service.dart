import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../utils/notification_util.dart';
import '../../utils/storage_util.dart';

class NotificationService extends GetxService {
  final String topicName = 'donuthelp';
  final fcmToken = RxnString();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final status = Rx<AuthorizationStatus>(AuthorizationStatus.authorized);

  Future<NotificationService> init() async {
    final String? statusValue = await getStatus();
    if (statusValue == null) {
      await requestPermission();
    } else if (statusValue == AuthorizationStatus.authorized.toString()) {
      final token = await messaging.getToken();
      fcmToken.value = token;

      await handleNotification();
      await subscribeToTopic(topicName);
    }

    return this;
  }

  /// Disable notification
  Future<void> disableNotification() async {
    try {
      await setStatus(AuthorizationStatus.denied.toString());
      status.value = AuthorizationStatus.denied;
    } finally {}
  }

  /// Enable notification
  Future<void> enableNotification() async {
    try {
      await requestPermission();
      await setStatus(AuthorizationStatus.authorized.toString());
      status.value = AuthorizationStatus.authorized;
    } finally {}
  }

  /// Request permission to receive notifications
  Future<void> requestPermission() async {
    NotificationSettings currentSettings =
        await messaging.getNotificationSettings();

    if (currentSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined ||
        currentSettings.authorizationStatus ==
            AuthorizationStatus.provisional ||
        currentSettings.authorizationStatus == AuthorizationStatus.denied) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      await setStatus(settings.authorizationStatus.toString());

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await enableNotification();
        await subscribeToTopic(topicName);
        await handleNotification();
      }
    } else {
      await setStatus(currentSettings.authorizationStatus.toString());
      fcmToken.value = await messaging.getToken();
    }
  }

  /// Handle notification
  Future<void> handleNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await NotificationUtil.onMessageHandler(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await NotificationUtil.onMessageOpenedAppHandler(message);
    });
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }

  /// Get status
  Future<String?> getStatus() async {
    String? statusValue = await StorageUtil.securedRead('notificationStatus');

    if (statusValue == AuthorizationStatus.authorized.toString()) {
      status.value = AuthorizationStatus.authorized;
    } else if (statusValue == AuthorizationStatus.denied.toString()) {
      status.value = AuthorizationStatus.denied;
    } else if (statusValue == AuthorizationStatus.provisional.toString()) {
      status.value = AuthorizationStatus.provisional;
    } else {
      status.value = AuthorizationStatus.notDetermined;
    }

    return statusValue;
  }

  /// Set status
  Future setStatus(String status) async {
    await StorageUtil.securedWrite('notificationStatus', status);
  }
}
