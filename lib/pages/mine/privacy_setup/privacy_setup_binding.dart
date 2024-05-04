import 'package:get/get.dart';

import 'privacy_setup_logic.dart';

class PrivacySetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacySetupLogic());
  }
}
