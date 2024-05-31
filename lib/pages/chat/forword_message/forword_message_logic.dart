import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:privchat/pages/contacts/add_by_search/add_by_search_logic.dart';
import 'package:privchat/routes/app_navigator.dart';
import '../chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

import '../../../core/controller/im_controller.dart';

class ForwordMessageLogic extends GetxController {

  var selectedContacts = <String>[].obs; // List of selected contacts
  final logic = Get.find<ChatLogic>(tag: GetTags.chat);
  final friendList = <ISUserInfo>[].obs;
  final userIDList = <String>[];
  var forwordMsg;

  @override
  void onInit() {
    forwordMsg = Get.arguments['message'];
    refreshList();
    super.onInit();
  }

  @override
  void onReady() {
    refreshList();
    super.onReady();
  }

  @override
  void onClose() {
    friendList.value = [];
    super.onClose();
  }
  // Method to forward a message
  void forwardMessage(Message message, List<String> recipientIds) async {
    for (String recipientId in recipientIds) {
      // 获取原始消息
      // 转发消息
      var createNewForwordmsg = await OpenIM.iMManager.messageManager.createForwardMessage(
          message: message);
      logic.sendForwordMessage(createNewForwordmsg, userId: recipientId);
    }
  }

  void refreshList() {
    _getFriendList();
  }

  _getFriendList() async {
    final list = await OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where(_filterBlacklist))
        .then((list) => list.map((e) {
      final fullUser = FullUserInfo.fromJson(e);
      final user = fullUser.friendInfo != null
          ? ISUserInfo.fromJson(fullUser.friendInfo!.toJson())
          : ISUserInfo.fromJson(fullUser.publicInfo!.toJson());
      return user;
    }).toList())
        .then((list) => IMUtils.convertToAZList(list));

    onUserIDList(userIDList);
    friendList.assignAll(list.cast<ISUserInfo>());
  }

  void onUserIDList(List<String> userIDList) {}

  bool _filterBlacklist(e) {
    final user = FullUserInfo.fromJson(e);
    final isBlack = user.blackInfo != null;

    if (isBlack) {
      return false;
    } else {
      userIDList.add(user.userID);
      return true;
    }
  }

  _addFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      _addUser(user.toJson());
    }
  }

  _delFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      friendList.removeWhere((e) => e.userID == user.userID);
    }
  }

  _friendInfoChanged(FriendInfo user) {
    friendList.removeWhere((e) => e.userID == user.userID);
    _addUser(user.toJson());
  }

  void _addUser(Map<String, dynamic> json) {
    final info = ISUserInfo.fromJson(json);
    friendList.add(IMUtils.setAzPinyinAndTag(info) as ISUserInfo);

    SuspensionUtil.sortListBySuspensionTag(friendList);

    SuspensionUtil.setShowSuspensionStatus(friendList);
  }

  void viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
    userID: info.userID!,
    account: info.account!,
  );

  void searchFriend() => AppNavigator.startSearchFriend();


}