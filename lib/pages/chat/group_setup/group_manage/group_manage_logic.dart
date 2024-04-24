import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:privchat/pages/chat/chat_logic.dart';
import 'package:privchat/pages/chat/group_setup/edit_name/edit_name_logic.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:synchronized/synchronized.dart';

import '../../../../core/controller/app_controller.dart';
import '../../../../core/controller/im_controller.dart';
import '../../../../routes/app_navigator.dart';
import '../../../contacts/select_contacts/select_contacts_logic.dart';
import '../../../conversation/conversation_logic.dart';

class GroupManageLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  final chatLogic = Get.find<ChatLogic>(tag: GetTags.chat);
  final appLogic = Get.find<AppController>();
  final conversationLogic = Get.find<ConversationLogic>();
  final memberList = <GroupMembersInfo>[].obs;
  late Rx<GroupInfo> groupInfo;
  late Rx<GroupMembersInfo> myGroupMembersInfo;
  final lock = Lock();
  final isJoinedGroup = false.obs;

  @override
  void onInit() {
    groupInfo = Rx(_defaultGroupInfo);
    myGroupMembersInfo = Rx(_defaultMemberInfo);
    super.onInit();
  }

  @override
  void onReady() {
    _checkIsJoinedGroup();
    super.onReady();
  }

  get _defaultGroupInfo => GroupInfo(
        groupID: chatLogic.conversationInfo.value.groupID!,
        groupName: chatLogic.conversationInfo.value.showName,
        faceURL: chatLogic.conversationInfo.value.faceURL,
        memberCount: 0,
      );

  get _defaultMemberInfo => GroupMembersInfo(
        userID: OpenIM.iMManager.userID,
        nickname: OpenIM.iMManager.userInfo.nickname,
      );

  bool get isOwnerOrAdmin => isOwner || isAdmin;

  bool get isAdmin => myGroupMembersInfo.value.roleLevel == GroupRoleLevel.admin;

  bool get isOwner => groupInfo.value.ownerUserID == OpenIM.iMManager.userID;

  bool get isPinned => chatLogic.conversationInfo.value.isPinned == true;

  bool get isNotDisturb => chatLogic.conversationInfo.value.recvMsgOpt != 0;

  String get conversationID => chatLogic.conversationInfo.value.conversationID;

  void _checkIsJoinedGroup() async {
    isJoinedGroup.value = await OpenIM.iMManager.groupManager.isJoinedGroup(
      groupID: groupInfo.value.groupID,
    );
    _queryAllInfo();
  }

  void _queryAllInfo() {
    if (isJoinedGroup.value) {
      getGroupInfo();
    }
  }

  getGroupInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      groupIDList: [groupInfo.value.groupID],
    );
    var value = list.firstOrNull;
    if (null != value) {
      _updateGroupInfo(value);
    }
  }

  void _updateGroupInfo(GroupInfo value) {
    groupInfo.update((val) {
      val?.groupName = value.groupName;
      val?.faceURL = value.faceURL;
      val?.notification = value.notification;
      val?.introduction = value.introduction;
      val?.memberCount = value.memberCount;
      val?.ownerUserID = value.ownerUserID;
      val?.status = value.status;
      val?.needVerification = value.needVerification;
      val?.groupType = value.groupType;
      val?.lookMemberInfo = value.lookMemberInfo;
      val?.applyMemberFriend = value.applyMemberFriend;
      val?.notificationUserID = value.notificationUserID;
      val?.notificationUpdateTime = value.notificationUpdateTime;
      val?.ex = value.ex;
    });
  }
}
