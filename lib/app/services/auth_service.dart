import 'package:get/get.dart';

import '../../utils/catcher_util.dart';
import '../../utils/storage_util.dart';
import '../data/models/user_model.dart';
import '../data/providers/auth_provider.dart';
import '../routes/app_pages.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  final token = RxnString('');
  final user = Rxn<UserModel>();
  final authenticated = RxBool(false);

  Future<AuthService> init() async {
    await getToken();
    return this;
  }

  Future getToken() async {
    String? tokenResult = await StorageUtil.securedRead('token');
    token.value = tokenResult;
  }

  Future<void> getUser() async {
    if (token.value == '' || token.value == null) {
      return;
    }

    try {
      var response = await ApiService.get('auth/user');

      if (response != null) {
        await setUser(UserModel.fromJson(response));
        authenticated.value = true;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
      authenticated.value = false;
    }
  }

  Future setUser(UserModel? userResult) async {
    user.value = userResult;
  }

  Future setToken(String tokenResult) async {
    await StorageUtil.securedWrite('token', tokenResult);
    token.value = tokenResult;
  }

  Future<void> signOut() async {
    await setToken('');
    token.value = '';
    user.value = null;
    authenticated.value = false;
    Get.offAllNamed(Routes.AUTH);
  }

  Future<void> deactivate() async {
    /// update user
    switch (user.value!.tokenableType) {
      case 'user':
        await AuthProvider.deactivateUserAccount();
        break;
      case 'staff':
        await AuthProvider.deactivateStaffAccount();
        break;
      case 'agency':
        await AuthProvider.deactivateAgencyAccount();
        break;
    }

    await signOut();
  }
}
