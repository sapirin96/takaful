import '../../../utils/catcher_util.dart';
import '../../services/api_service.dart';
import '../models/bank_account_model.dart';

class BankAccountProvider {
  static Future<List<BankAccountModel>> index({
    int? page,
    int? perPage,
  }) async {
    List<BankAccountModel> items = [];
    try {
      var response = await ApiService.get('insurance/donation_accounts');

      if (response != null) {
        (response as List).map((item) {
          items.add(BankAccountModel.fromJson(item));
        }).toList();
      }
    } catch (error, stackTrace) {
      CatcherUtil.report(error, stackTrace);
    }
    return items;
  }
}
