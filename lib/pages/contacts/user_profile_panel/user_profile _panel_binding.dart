import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import 'user_profile _panel_logic.dart';

class UserProfilePanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfilePanelLogic(), tag: GetTags.userProfile);
  }
}
