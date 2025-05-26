import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/claim_model.dart';

class ClaimProvider {
  /// Get paginated claims
  /// @return List<ClaimModel>
  /// @throws Exception
  static Future<List<ClaimModel>> paginated({
    int? page,
    int? perPage,
    Map<String, dynamic>? params,
  }) async {
    List<ClaimModel> items = [];
    try {
      var response = await ApiService.get('insurance/claims', params: {
        'page': page,
        'per_page': perPage,
        ...?params,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(ClaimModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store claim
  /// @return ClaimModel
  /// @throws Exception
  static Future<ClaimModel?> store(FormData formData) async {
    ClaimModel? item;
    try {
      var response = await ApiService.post('insurance/claims', data: formData);

      if (response != null) {
        item = ClaimModel.fromJson(response['claim']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show claim
  /// @return ClaimModel
  /// @throws Exception
  /// @param String uuid
  static Future<ClaimModel?> show(String uuid) async {
    ClaimModel? item;
    try {
      var response = await ApiService.get('insurance/claims/$uuid');

      if (response != null) {
        item = ClaimModel.fromJson(response['claim']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update claim
  /// @return ClaimModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<ClaimModel?> update(
    String uuid,
    FormData formData,
  ) async {
    ClaimModel item = ClaimModel();
    try {
      var response =
          await ApiService.post('insurance/claims/$uuid', data: formData);

      if (response != null) {
        item = ClaimModel.fromJson(response['claim']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete claim
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/claims/$uuid');

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
