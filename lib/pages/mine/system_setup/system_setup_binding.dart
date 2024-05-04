import 'package:get/get.dart';

import 'system_setup_logic.dart';

class SystemSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SystemSetupLogic());
  }
}
