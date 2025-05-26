import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/submember_model.dart';

class SubmemberProvider {
  /// Get paginated submembers
  /// @return List<SubmemberModel>
  /// @throws Exception
  static Future<List<SubmemberModel>> paginated({
    int? page,
    int? perPage,
    int? memberId,
  }) async {
    List<SubmemberModel> items = [];
    try {
      var response = await ApiService.get('insurance/submembers', params: {
        'page': page,
        'per_page': perPage,
        'parent_id': memberId,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(SubmemberModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store submember
  /// @return SubmemberModel
  /// @throws Exception
  static Future<SubmemberModel?> store(
    FormData formData, {
    int? memberId,
  }) async {
    SubmemberModel? item;
    try {
      var response = await ApiService.post(
        'insurance/submembers',
        data: formData,
        params: {
          'parent_id': memberId,
        },
      );

      if (response != null) {
        item = SubmemberModel.fromJson(response['submember']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show submember
  /// @return SubmemberModel
  /// @throws Exception
  /// @param String uuid
  static Future<SubmemberModel?> show(
    String uuid, {
    int? memberId,
  }) async {
    SubmemberModel item = SubmemberModel();
    try {
      var response = await ApiService.get(
        'insurance/submembers/$uuid',
        params: {
          'parent_id': memberId,
        },
      );

      if (response != null) {
        item = SubmemberModel.fromJson(response['submember']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update submember
  /// @return SubmemberModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<SubmemberModel?> update(
    String uuid,
    FormData formData, {
    int? memberId,
  }) async {
    SubmemberModel? item;
    try {
      var response = await ApiService.post(
        'insurance/submembers/$uuid',
        data: formData,
        params: {
          'parent_id': memberId,
        },
      );

      if (response != null) {
        item = SubmemberModel.fromJson(response['submember']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete submember
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/submembers/$uuid');

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
