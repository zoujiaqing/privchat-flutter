import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

import '../../widgets/chat_input_box/chat_input_box_logic.dart';
import 'chat_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatLogic(), tag: GetTags.chat);
    Get.lazyPut(() => ChatInputBoxLogic());
  }
}
