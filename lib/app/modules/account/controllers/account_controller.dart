import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../services/auth_service.dart';

class AccountController extends GetxController {
  /// initialize auth service
  final AuthService auth = Get.find<AuthService>();

  /// Update user
  Future<void> updateUser(FormData data) async {
    final UserModel? user = await AuthProvider.updateUserAccount(data);

    if (user != null) {
      await auth.setUser(user);
      Get.rawSnackbar(message: 'Profile updated successfully!'.tr);
    } else {
      Get.rawSnackbar(
        message: 'Failed to update profile!'.tr,
        backgroundColor: Colors.red,
      );
    }
  }

  /// Update staff
  Future<void> updateStaff(FormData data) async {
    final UserModel? user = await AuthProvider.updateStaffAccount(data);

    if (user != null) {
      await auth.setUser(user);
      Get.rawSnackbar(message: 'Profile updated successfully!'.tr);
    } else {
      Get.rawSnackbar(
        message: 'Failed to update profile!'.tr,
        backgroundColor: Colors.red,
      );
    }
  }

  /// Update agency
  Future<void> updateAgency(FormData data) async {
    final UserModel? user = await AuthProvider.updateAgencyAccount(data);

    if (user != null) {
      await auth.setUser(user);
      Get.rawSnackbar(message: 'Profile updated successfully!'.tr);
    } else {
      Get.rawSnackbar(
        message: 'Failed to update profile!'.tr,
        backgroundColor: Colors.red,
      );
    }
  }
}
