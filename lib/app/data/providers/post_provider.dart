import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/post_model.dart';

class PostProvider {
  static Future<List<PostModel>> paginated({
    int? page,
    int? perPage,
  }) async {
    List<PostModel> items = [];
    try {
      var response = await ApiService.get('posts', params: {
        'page': page,
        'per_page': perPage,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(PostModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  static Future<Map<String, dynamic>> singlePost({String? postUuId}) async {
    Map<String, dynamic> item = {};
    try {
      var response = await ApiService.get('posts/$postUuId');
      if (response != null) {
        item = response;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }
}
