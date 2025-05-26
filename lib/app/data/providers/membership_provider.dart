import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/subscription_model.dart';

class MembershipProvider {
  /// Renew membership
  static Future<SubscriptionModel?> renew(Map<String, dynamic> data) async {
    SubscriptionModel? item;
    try {
      var response = await ApiService.post('insurance/membership/renew', data: data);

      if (response != null) {
        item = SubscriptionModel.fromJson(response);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return item;
  }

  /// check if subscription is active
  static Future<SubscriptionModel?> checkSubscription(String uuid) async {
    SubscriptionModel? item;
    try {
      var response = await ApiService.get('insurance/membership/subscriptions/$uuid/show');

      if (response != null) {
        item = SubscriptionModel.fromJson(response);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return item;
  }
}
