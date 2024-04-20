import 'package:get/get.dart';
import 'package:privchat/pages/chat/group_setup/group_setup_logic.dart';
import 'package:privchat_common/privchat_common.dart';

class GroupQrcodeLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupSetupLogic>();

  String buildQRContent() {
    return '${Config.groupScheme}${groupSetupLogic.groupInfo.value.groupID}';
  }
}
