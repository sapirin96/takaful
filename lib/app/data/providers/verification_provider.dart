import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';

class VerificationProvider {
  /// Check if member
  static Future<bool?> isMember() async {
    bool? data;
    try {
      var response = await ApiService.get('insurance/verification/is_member');

      if (response != null) {
        data = response['data'];
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return data;
  }

  /// Check if profile is completed
  static Future<bool?> isProfileCompleted() async {
    bool? data;
    try {
      var response =
          await ApiService.get('insurance/verification/is_profile_completed');

      if (response != null) {
        data = response['data'];
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return data;
  }
}
