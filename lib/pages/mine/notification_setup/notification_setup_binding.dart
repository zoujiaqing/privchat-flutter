import 'package:get/get.dart';

import 'notification_setup_logic.dart';

class NotificationSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSetupLogic());
  }
}
