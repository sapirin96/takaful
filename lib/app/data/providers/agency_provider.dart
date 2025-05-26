import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/agency_model.dart';

class AgencyProvider {
  /// Get paginated agencies
  /// @return List<AgencyModel>
  /// @throws Exception
  static Future<List<AgencyModel>> paginated({
    int? page,
    int? perPage,
    bool? isSuperAgency,
    bool? isAgency,
    String? parentUuid,
    Map<String, dynamic>? params,
  }) async {
    List<AgencyModel> items = [];
    try {
      var response = await ApiService.get('insurance/agencies', params: {
        'page': page,
        'per_page': perPage,
        'is_super_agency': isSuperAgency,
        'is_agency': isAgency,
        'parent_uuid': parentUuid,
        ...?params,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(AgencyModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store agency
  /// @return AgencyModel
  /// @throws Exception
  static Future<AgencyModel?> store(FormData formData) async {
    AgencyModel? item;
    try {
      var response =
          await ApiService.post('insurance/agencies', data: formData);

      if (response != null) {
        item = AgencyModel.fromJson(response['agency']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show agency
  /// @return AgencyModel
  /// @throws Exception
  /// @param String uuid
  static Future<AgencyModel?> show(String uuid) async {
    AgencyModel item = AgencyModel();
    try {
      var response = await ApiService.get('insurance/agencies/$uuid');

      if (response != null) {
        item = AgencyModel.fromJson(response['agency']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update agency
  /// @return AgencyModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<AgencyModel?> update(
    String uuid,
    FormData formData,
  ) async {
    AgencyModel? item;
    try {
      var response =
          await ApiService.post('insurance/agencies/$uuid', data: formData);

      if (response != null) {
        item = AgencyModel.fromJson(response['agency']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete agency
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/agencies/$uuid');

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
