import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/staff_model.dart';

class StaffProvider {
  /// Get paginated staffs
  /// @return List<StaffModel>
  /// @throws Exception
  static Future<List<StaffModel>> paginated({
    int? page,
    int? perPage,
    Map<String, dynamic>? params,
  }) async {
    List<StaffModel> items = [];
    try {
      var response = await ApiService.get('insurance/staffs', params: {
        'page': page,
        'per_page': perPage,
        ...?params,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(StaffModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store staff
  /// @return StaffModel
  /// @throws Exception
  static Future<StaffModel?> store(FormData formData) async {
    StaffModel? item;
    try {
      var response = await ApiService.post('insurance/staffs', data: formData);

      if (response != null) {
        item = StaffModel.fromJson(response['staff']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show staff
  /// @return StaffModel
  /// @throws Exception
  /// @param String uuid
  static Future<StaffModel?> show(String uuid) async {
    StaffModel item = StaffModel();
    try {
      var response = await ApiService.get('insurance/staffs/$uuid');

      if (response != null) {
        item = StaffModel.fromJson(response['staff']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update staff
  /// @return StaffModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<StaffModel?> update(
    String uuid,
    FormData formData,
  ) async {
    StaffModel? item;
    try {
      var response =
          await ApiService.post('insurance/staffs/$uuid', data: formData);

      if (response != null) {
        item = StaffModel.fromJson(response['staff']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete staff
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/staffs/$uuid');

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
