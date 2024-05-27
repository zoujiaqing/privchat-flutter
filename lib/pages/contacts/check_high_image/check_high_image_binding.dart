import 'package:get/get.dart';

import 'check_high_image_logic.dart';

class CheckHighImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckHighImageLogic());
  }
}