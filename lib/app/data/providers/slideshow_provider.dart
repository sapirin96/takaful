import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/slideshow_model.dart';

class SlideShowProvider {
  /// Get all
  static Future<List<SlideShowModel>> get() async {
    List<SlideShowModel> items = [];
    try {
      var response = await ApiService.get('slideshows');
      if (response != null) {
        (response as List).map((item) {
          items.add(SlideShowModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Paginate 20 items per page
  static Future<List<SlideShowModel>> paginated({
    int? page = 1,
    int? limit = 20,
  }) async {
    List<SlideShowModel> items = [];
    try {
      var response = await ApiService.get('slideshows/paginate', params: {
        'page': page,
        'limit': limit,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(SlideShowModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Count slideshow on view
  static Future<bool?> count({required String uuid}) async {
    bool? success;
    try {
      var response = await ApiService.get('slideshows/$uuid/count');

      if (response != null) {
        success = response;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return success;
  }
}
