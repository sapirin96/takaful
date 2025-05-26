import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/zakat_model.dart';

class ZakatProvider {
  /// Get paginated zakats
  /// @return List<ZakatModel>
  /// @throws Exception
  static Future<List<ZakatModel>> paginated({
    int? page,
    int? perPage,
  }) async {
    List<ZakatModel> items = [];
    try {
      var response = await ApiService.get('insurance/zakats', params: {
        'page': page,
        'per_page': perPage,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(ZakatModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store zakat
  /// @return ZakatModel
  /// @throws Exception
  static Future<ZakatModel?> store(Map<String, dynamic> formData) async {
    ZakatModel? item;
    try {
      var response = await ApiService.post('insurance/zakats', data: formData);

      if (response != null) {
        item = ZakatModel.fromJson(response['zakat']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show zakat
  /// @return ZakatModel
  /// @throws Exception
  /// @param String uuid
  static Future<ZakatModel?> show(String uuid) async {
    ZakatModel? item;
    try {
      var response = await ApiService.get('insurance/zakats/$uuid');

      if (response != null) {
        item = ZakatModel.fromJson(response['zakat']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Update zakat
  /// @return ZakatModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<ZakatModel?> update(
    String uuid,
    Map<String, dynamic> formData,
  ) async {
    ZakatModel item = ZakatModel();
    try {
      var response = await ApiService.put('insurance/zakats/$uuid', data: formData);

      if (response != null) {
        item = ZakatModel.fromJson(response['zakat']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete zakat
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/zakats/$uuid');

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
