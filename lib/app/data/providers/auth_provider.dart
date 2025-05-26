import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:takaful/app/data/models/user_model.dart';
import 'package:takaful/utils/catcher_util.dart';

import '../../../utils/device_util.dart';
import '../../services/api_service.dart';

class AuthProvider {
  /// Register as user
  static Future<Map<String, dynamic>?> registerAsUser({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'auth/register',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// Login as user
  static Future<Map<String, dynamic>?> loginAsUser({
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'auth/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// Register as member
  static Future<Map<String, dynamic>?> registerAsMember({
    required String nameKh,
    required String nameEn,
    required String phone,
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'insurance/auth/member/register',
      data: {
        'name_kh': nameKh,
        'name_en': nameEn,
        'phone': phone,
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// Login as member
  static Future<Map<String, dynamic>?> loginAsMember({
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'insurance/auth/member/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// Login as staff
  static Future<Map<String, dynamic>?> loginAsStaff({
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'insurance/auth/staff/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// Login as agency
  static Future<Map<String, dynamic>?> loginAsAgency({
    required String email,
    required String password,
  }) async {
    var deviceName = await DeviceUtil.getId();

    var response = await ApiService.post(
      'insurance/auth/agency/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );

    return response;
  }

  /// update user account
  static Future<UserModel?> updateUserAccount(FormData data) async {
    UserModel? user;
    try {
      var response = await ApiService.post(
        'auth/update_profile',
        data: data,
      );

      if (response != null) {
        user = UserModel.fromJson(response);
      }

      return user;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return user;
  }

  /// update staff account
  static Future<UserModel?> updateStaffAccount(FormData data) async {
    UserModel? user;
    try {
      var response = await ApiService.post(
        'insurance/auth/staff/update_profile',
        data: data,
      );

      if (response != null) {
        user = UserModel.fromJson(response);
      }

      return user;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return user;
  }

  /// update staff account
  static Future<UserModel?> updateAgencyAccount(FormData data) async {
    UserModel? user;
    try {
      var response = await ApiService.post(
        'insurance/auth/agency/update_profile',
        data: data,
      );

      if (response != null) {
        user = UserModel.fromJson(response);
      }

      return user;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return user;
  }

  /// Deactivate user account
  static Future<void> deactivateUserAccount() async {
    try {
      var result = await ApiService.post('auth/deactivate');
      if (result != null) {
        EasyLoading.showSuccess(result);
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }

  /// Deactivate staff account
  static Future<void> deactivateStaffAccount() async {
    try {
      var result = await ApiService.post('insurance/auth/staff/deactivate');
      if (result != null) {
        EasyLoading.showSuccess(result);
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }

  /// Deactivate agency account
  static Future<void> deactivateAgencyAccount() async {
    try {
      var result = await ApiService.post('insurance/auth/agency/deactivate');
      if (result != null) {
        EasyLoading.showSuccess(result);
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
  }
}
