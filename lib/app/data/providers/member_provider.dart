import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/member_model.dart';

class MemberProvider {
  /// Get paginated members
  /// @return List<MemberModel>
  /// @throws Exception
  static Future<List<MemberModel>> paginated({
    int? page,
    int? perPage,
    String? agencyUuid,
    Map<String, dynamic>? params,
  }) async {
    List<MemberModel> items = [];
    try {
      var response = await ApiService.get('insurance/members', params: {
        'page': page,
        'per_page': perPage,
        'agency_uuid': agencyUuid,
        ...?params,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(MemberModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store member
  /// @return MemberModel
  /// @throws Exception
  static Future<MemberModel?> store(FormData formData) async {
    MemberModel? item;
    try {
      var response = await ApiService.post('insurance/members', data: formData);

      if (response != null) {
        item = MemberModel.fromJson(response['member']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show member
  /// @return MemberModel
  /// @throws Exception
  /// @param String uuid
  static Future<MemberModel?> show(String uuid) async {
    MemberModel item = MemberModel();
    try {
      var response = await ApiService.get('insurance/members/$uuid');

      if (response != null) {
        item = MemberModel.fromJson(response['member']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update member
  /// @return MemberModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<MemberModel?> update(
    String uuid,
    FormData formData,
  ) async {
    MemberModel? item;
    try {
      var response =
          await ApiService.post('insurance/members/$uuid', data: formData);

      if (response != null) {
        item = MemberModel.fromJson(response['member']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete member
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/members/$uuid');

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
