import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';

class DataProvider {
  /// get roles data
  static Future<List<Map<String, dynamic>>> roles() async {
    List<Map<String, dynamic>> items = [];
    try {
      var exclude = 'administrator';

      var response = await ApiService.get('admin/data/roles', params: {
        'exclude': exclude,
      });

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get plans data
  static Future<Map<String, dynamic>> statistic() async {
    Map<String, dynamic> item = {};
    try {
      var response = await ApiService.get('insurance/data/statistic');

      if (response != null) {
        item = response;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Get plans data
  static Future<List<Map<String, dynamic>>> plans() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/plans');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get members data
  static Future<List<Map<String, dynamic>>> members() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/members');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get staffs data
  static Future<List<Map<String, dynamic>>> staffs() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/staffs');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get agencies data
  static Future<List<Map<String, dynamic>>> agencies({int? staffId}) async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/agencies', params: {
        'filter[staff_id]': staffId,
      });

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get policies data
  static Future<List<Map<String, dynamic>>> member() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/member');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get policies data
  static Future<List<Map<String, dynamic>>> policies() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('insurance/data/policies');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get policies data
  static Future<Map<String, dynamic>?> compensation({
    dynamic waitingDuration,
    dynamic type,
    dynamic reasonsOfDeath,
    dynamic memberId,
    dynamic policyId,
  }) async {
    Map<String, dynamic>? item;
    try {
      var response = await ApiService.get(
        'insurance/data/compensation',
        params: {
          'waiting_duration': waitingDuration,
          'type': type,
          'reasons_of_death': reasonsOfDeath,
          'member_id': memberId,
          'policy_id': policyId,
        },
      );

      if (response != null) {
        item = response as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Get provinces data
  static Future<List<Map<String, dynamic>>> provinces() async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('cambodia/data/provinces');

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get districts data
  static Future<List<Map<String, dynamic>>> districts({int? provinceId}) async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('cambodia/data/districts', params: {
        'filter[province_id]': provinceId,
      });

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get communes data
  static Future<List<Map<String, dynamic>>> communes(
      {int? provinceId, int? districtId}) async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('cambodia/data/communes', params: {
        'filter[province_id]': provinceId,
        'filter[district_id]': districtId,
      });

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get villages data
  static Future<List<Map<String, dynamic>>> villages(
      {int? provinceId, int? districtId, int? communeId}) async {
    List<Map<String, dynamic>> items = [];
    try {
      var response = await ApiService.get('cambodia/data/villages', params: {
        'filter[province_id]': provinceId,
        'filter[district_id]': districtId,
        'filter[commune_id]': communeId,
      });

      if (response != null) {
        (response as List).map((item) {
          items.add(item);
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }

  /// Get policies data
  static Future<Map<String, dynamic>> nextSubscriptionDate({
    dynamic memberId,
  }) async {
    Map<String, dynamic> item = {};
    try {
      var response = await ApiService.get(
          'insurance/data/next_subscription_date/$memberId');

      if (response != null) {
        item = response as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Get super consultants data
  static Future<Map<String, dynamic>> getSuperConsultantsData() async {
    Map<String, dynamic> item = {};
    try {
      var response = await ApiService.get('insurance/data/super_consultants');

      if (response != null) {
        item = response as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Get consultants data of super consultant
  static Future<Map<String, dynamic>> getConsultantsData({
    String? superConsultantUuid,
  }) async {
    Map<String, dynamic> item = {};
    try {
      var response = await ApiService.get(
          'insurance/data/consultants/$superConsultantUuid');

      if (response != null) {
        item = response as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }

  /// Get members data of consultant
  static Future<Map<String, dynamic>> getMembersData({
    String? consultantUuid,
  }) async {
    Map<String, dynamic> item = {};
    try {
      var response =
          await ApiService.get('insurance/data/members/$consultantUuid');

      if (response != null) {
        item = response as Map<String, dynamic>;
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return item;
  }
}
