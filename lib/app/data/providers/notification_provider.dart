import '../../../configs/app_config.dart';
import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/notification_model.dart';

class NotificationProvider {
  static Future<List<NotificationModel>> getNotification({int page = 1, int limit = AppConfig.pageSize}) async {
    List<NotificationModel> items = [];
    try {
      var response = await ApiService.get('notifications', params: {
        "page": page,
        "limit": limit,
      });
      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(NotificationModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return items;
  }
}
