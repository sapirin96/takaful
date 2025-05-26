import 'package:get/get.dart';

import '../data/models/language_model.dart';
import 'km_KH.dart';

class Messages extends Translations {
  static final List<LanguageModel> languages = [
    LanguageModel(
      code: 'km_KH',
      name: 'ភាសាខ្មែរ',
      assetUrl: 'lib/assets/icons/cambodia.png',
    ),
    LanguageModel(
      code: 'en_US',
      name: 'English',
      assetUrl: 'lib/assets/icons/english.png',
    ),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        "km_KH": kmKH,
      };
}
