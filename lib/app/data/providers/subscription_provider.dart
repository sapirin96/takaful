import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/subscription_model.dart';

class SubscriptionProvider {
  /// Get paginated subscriptions
  /// @return List<SubscriptionModel>
  /// @throws Exception
  static Future<List<SubscriptionModel>> paginated({
    int? page,
    int? perPage,
    Map<String, dynamic>? params,
  }) async {
    List<SubscriptionModel> items = [];
    try {
      var response = await ApiService.get('insurance/subscriptions', params: {
        'page': page,
        'per_page': perPage,
        ...?params,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(SubscriptionModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store subscription
  /// @return SubscriptionModel
  /// @throws Exception
  static Future<SubscriptionModel?> store(FormData formData) async {
    SubscriptionModel item = SubscriptionModel();
    try {
      var response =
          await ApiService.post('insurance/subscriptions', data: formData);

      if (response != null) {
        item = SubscriptionModel.fromJson(response['subscription']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show subscription
  /// @return SubscriptionModel
  /// @throws Exception
  /// @param String uuid
  static Future<SubscriptionModel?> show(String uuid) async {
    SubscriptionModel? item;
    try {
      var response = await ApiService.get('insurance/subscriptions/$uuid');

      if (response != null) {
        item = SubscriptionModel.fromJson(response['subscription']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update subscription
  /// @return SubscriptionModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<SubscriptionModel?> update(
    String uuid,
    FormData formData,
  ) async {
    SubscriptionModel? item;
    try {
      var response = await ApiService.post('insurance/subscriptions/$uuid',
          data: formData);

      if (response != null) {
        item = SubscriptionModel.fromJson(response['subscription']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete subscription
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/subscriptions/$uuid');

      if (response != null) {
        EasyLoading.showSuccess(response);
        return true;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    } finally {
      EasyLoading.dismiss(animation: true);
    }
    return false;
  }
}
