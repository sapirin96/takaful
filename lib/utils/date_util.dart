import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../app/services/setting_service.dart';

class DateUtil {
  static String format(
    DateTime dateTime, {
    String format = 'EEEE, dd MMMM yyyy',
  }) {
    initializeDateFormatting();
    Intl.defaultLocale = Get.find<SettingService>().defaultLocale.value;

    var formatter = DateFormat(format);
    String formatted = formatter.format(dateTime);

    return formatted;
  }

  static DateTime parse(String dateString, {String format = "yyyy-MM-dd"}) {
    return DateFormat(format).parse(dateString);
  }
}
