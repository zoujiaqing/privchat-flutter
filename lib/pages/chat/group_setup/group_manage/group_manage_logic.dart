import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:privchat/pages/chat/chat_logic.dart';
import 'package:privchat/pages/chat/group_setup/edit_name/edit_name_logic.dart';
import 'package:privchat/pages/chat/group_setup/group_setup_logic.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:synchronized/synchronized.dart';

import '../../../../core/controller/app_controller.dart';
import '../../../../core/controller/im_controller.dart';
import '../../../../routes/app_navigator.dart';
import '../../../contacts/select_contacts/select_contacts_logic.dart';
import '../../../conversation/conversation_logic.dart';

class GroupManageLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupSetupLogic>();
  
  void setGroupMute(bool mute) async {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.groupManager.changeGroupMute(
            groupID: groupSetupLogic.groupInfo.value.groupID,
            mute: mute,
          ).then((value) => groupSetupLogic.groupInfo.update((val) {
            val?.status = mute ? 3 : 0;
          }))
    );
  }

  void setDisableViewMemberProfile(bool disabled) async {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.groupManager
            .setGroupInfo(GroupInfo(groupID: groupSetupLogic.groupInfo.value.groupID, lookMemberInfo: disabled ? 0 : 1))
            .then((value) => groupSetupLogic.groupInfo.update((val) {
              val?.lookMemberInfo = disabled ? 0 : 1;
            }))
    );
  }

  void setDisableMemberAddFriend(bool disabled) async {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.groupManager
            .setGroupInfo(GroupInfo(groupID: groupSetupLogic.groupInfo.value.groupID, applyMemberFriend: disabled ? 0 : 1))
            .then((value) => groupSetupLogic.groupInfo.update((val) {
              val?.applyMemberFriend = disabled ? 0 : 1;
            }))
    );
  }
}
