import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/partner_model.dart';

class PartnerProvider {
  /// Get all
  static Future<List<PartnerModel>> get() async {
    List<PartnerModel> items = [];
    try {
      var response = await ApiService.get('insurance/partners');
      if (response != null) {
        (response as List).map((item) {
          items.add(PartnerModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Paginate 20 items per page
  static Future<List<PartnerModel>> paginated({
    int? page = 1,
    int? limit = 20,
  }) async {
    List<PartnerModel> items = [];
    try {
      var response =
          await ApiService.get('insurance/partners/paginate', params: {
        'page': page,
        'limit': limit,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(PartnerModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Count partner on view
  static Future<bool?> count({required String uuid}) async {
    bool? success;
    try {
      var response = await ApiService.get('insurance/partners/$uuid/count');

      if (response != null) {
        success = response;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return success;
  }
}
