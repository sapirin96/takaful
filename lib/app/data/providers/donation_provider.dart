import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/utils.dart';

import '../../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/donation_model.dart';

class DonationProvider {
  /// Get paginated donations
  /// @return List<DonationModel>
  /// @throws Exception
  static Future<List<DonationModel>> paginated({
    int? page,
    int? perPage,
  }) async {
    List<DonationModel> items = [];
    try {
      var response = await ApiService.get('insurance/donations', params: {
        'page': page,
        'per_page': perPage,
      });

      if (response != null) {
        (response['data'] as List).map((item) {
          items.add(DonationModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Store donation
  /// @return DonationModel
  /// @throws Exception
  static Future<DonationModel?> store(Map<String, dynamic> formData) async {
    DonationModel? item;
    try {
      var response = await ApiService.post('insurance/donations', data: formData);

      if (response != null) {
        item = DonationModel.fromJson(response['donation']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Show donation
  /// @return DonationModel
  /// @throws Exception
  /// @param String uuid
  static Future<DonationModel?> show(String uuid) async {
    DonationModel? item;
    try {
      var response = await ApiService.get('insurance/donations/$uuid');

      if (response != null) {
        item = DonationModel.fromJson(response);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }

    return item;
  }

  /// Update donation
  /// @return DonationModel
  /// @throws Exception
  /// @param uuid
  /// @param formData
  static Future<DonationModel?> update(
    String uuid,
    Map<String, dynamic> formData,
  ) async {
    DonationModel item = DonationModel();
    try {
      var response = await ApiService.put('insurance/donations/$uuid', data: formData);

      if (response != null) {
        item = DonationModel.fromJson(response['donation']);
        EasyLoading.showSuccess(response['message']);
      }
      return item;
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Delete donation
  /// @return bool
  /// @throws Exception
  static Future<bool> delete(String uuid) async {
    try {
      EasyLoading.show(status: 'Deleting...'.tr);

      var response = await ApiService.delete('insurance/donations/$uuid');

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
