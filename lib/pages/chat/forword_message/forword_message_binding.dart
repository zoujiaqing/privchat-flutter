import 'package:get/get.dart';

import 'forword_message_logic.dart';

class ForwordMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForwordMessageLogic());
  }
}