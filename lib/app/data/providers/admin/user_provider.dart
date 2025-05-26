import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../utils/catcher_util.dart';
import '../../../services/api_service.dart';
import '../../models/admin/user_model.dart';

class UserProvider {
  /// Get paginated users
  /// @return List<UserModel>
  /// @throws Exception
  static Future<List<UserModel>> paginated({
    int? page,
    int? perPage,
  }) async {
    List<UserModel> items = [];
    try {
      var response = await ApiService.get('admin/users', params: {
        'page': page,
        'per_page': perPage,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(UserModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store user
  /// @return UserModel
  /// @throws Exception
  static Future<UserModel?> store(Map<String, dynamic> formData) async {
    UserModel? item;
    try {
      var response = await ApiService.post('admin/users', data: formData);

      if (response != null) {
        item = UserModel.fromJson(response['user']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show user
  /// @return UserModel
  /// @throws Exception
  /// @param String uuid
  static Future<UserModel?> show(String uuid) async {
    UserModel? item;
    try {
      var response = await ApiService.get('admin/users/$uuid');

      if (response != null) {
        item = UserModel.fromJson(response['user']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update user
  /// @return UserModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<UserModel?> update(
    String uuid,
    Map<String, dynamic> formData,
  ) async {
    UserModel? item;
    try {
      var response = await ApiService.put('admin/users/$uuid', data: formData);

      if (response != null) {
        item = UserModel.fromJson(response['user']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete user
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('admin/users/$uuid');

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
