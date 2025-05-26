import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    return authService.authenticated.value == true
        ? null
        : const RouteSettings(name: "/auth");
  }
}
