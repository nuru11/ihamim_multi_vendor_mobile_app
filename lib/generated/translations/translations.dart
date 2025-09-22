// import 'package:get/get.dart';
// import 'langs/en_US.dart';
// import 'langs/am_ET.dart';

// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//         'en_US': enUs,
//         'am_ET': amEt,
//       };
// }



import 'package:get/get.dart';
import 'langs/en_US.dart';
import 'langs/am_ET.dart';
import 'langs/zh_CN.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'am_ET': amEt,
        'zh_CN': zhCn, // ✅ Added Chinese
      };
}

