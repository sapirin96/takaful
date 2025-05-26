import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/device_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../main/controllers/main_controller.dart';

class AuthController extends GetxController {
  final AuthService auth = Get.find<AuthService>();

  /// Register as member
  Future<void> registerAsUser({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.registerAsUser(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }

  /// Login as member
  Future<void> loginAsUser({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.loginAsUser(
      email: email,
      password: password,
    );
    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }

  /// Register as member
  Future<void> registerAsMember({
    required String nameKh,
    required String nameEn,
    required String phone,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.registerAsMember(
      nameKh: nameKh,
      nameEn: nameEn,
      phone: phone,
      email: email,
      password: password,
    );
    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }

  /// Login as member
  Future<void> loginAsMember({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.loginAsMember(
      email: email,
      password: password,
    );
    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }

  /// Login as staff
  Future<void> loginAsStaff({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.loginAsStaff(
      email: email,
      password: password,
    );

    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }

  /// Login as agency
  Future<void> loginAsAgency({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic>? response = await AuthProvider.loginAsAgency(
      email: email,
      password: password,
    );
    if (response != null && response['token'] != null && response['user'] != null) {
      await auth.setToken(response['token']);
      await auth.getUser();
      await DeviceProvider.store();

      Get.lazyPut<MainController>(() => MainController());
      Get.offAndToNamed(AppPages.INITIAL);
    }
  }
}
