import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import '../../widgets/chat_input_box/chat_input_box_view.dart';
import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>(tag: GetTags.chat);
  ChatPage({super.key});

  Widget _buildItemView(Message message) =>
      ChatItemView(
        key: logic.itemKey(message),
        message: message,
        allAtMap: logic.getAtMapping(message),
        timelineStr: logic.getShowTime(message),
        sendStatusSubject: logic.sendStatusSub,
        sendProgressSubject: logic.sendProgressSub,
        leftNickname: logic.getNewestNickname(message),
        leftFaceUrl: logic.getNewestFaceURL(message),
        rightNickname: OpenIM.iMManager.userInfo.nickname,
        rightFaceUrl: OpenIM.iMManager.userInfo.faceURL,
        showLeftNickname: !logic.isSingleChat,
        showRightNickname: false,
        onFailedToResend: () => logic.failedResend(message),
        onClickItemView: () => logic.parseClickEvent(message),
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(message);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {
          logic.onTapLeftAvatar(message);
        },
        onTapRightAvatar: logic.onTapRightAvatar,
        onVisibleTrulyText: (text) {},
        customTypeBuilder: _buildCustomTypeItemView,
        onClickMenuTapItem: (idx, controller) {
          print(idx);
          logic.onClickMenuTapItem(idx, controller, message);
        },
      );

  CustomTypeInfo? _buildCustomTypeItemView(_, Message message) {
    final data = IMUtils.parseCustomMessage(message);
    if (null != data) {
      final viewType = data['viewType'];
      if (viewType == CustomMessageType.call) {
        final type = data['type'];
        final content = data['content'];
        final view = ChatCallItemView(type: type, content: content);
        return CustomTypeInfo(view);
      } else if (viewType == CustomMessageType.deletedByFriend ||
          viewType == CustomMessageType.blockedByFriend) {
        final view = ChatFriendRelationshipAbnormalHintView(
          name: logic.nickname.value,
          onTap: logic.sendFriendVerification,
          blockedByFriend: viewType == CustomMessageType.blockedByFriend,
          deletedByFriend: viewType == CustomMessageType.deletedByFriend,
        );
        return CustomTypeInfo(view, false, false);
      } else if (viewType == CustomMessageType.removedFromGroup) {
        return CustomTypeInfo(
          StrRes.removedFromGroupHint.toText..style = Styles.ts_8E9AB0_12sp,
          false,
          false,
        );
      } else if (viewType == CustomMessageType.groupDisbanded) {
        return CustomTypeInfo(
          StrRes.groupDisbanded.toText..style = Styles.ts_8E9AB0_12sp,
          false,
          false,
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.chat(
            title: logic.title,
            subTitle: logic.subTile,
            onCloseMultiModel: logic.exit,
            onClickMoreBtn: logic.chatSetup,
            onClickCallBtn: logic.call,
          ),
          body: WaterMarkBgView(
            // text: logic.markText,
            backgroundColor: Styles.c_FFFFFF,
            // bottomView: ChangeNotifierProvider<ProviderChatContent>(
            //   create: (BuildContext context) => ProviderChatContent(),
            //   child: Consumer(builder: (BuildContext context,
            //       ProviderChatContent providerChatContent, child) {
            //     return Builder(
            //       builder: (BuildContext context) {
            //         return ChatBottom(
            //           providerChatContent: providerChatContent,
            //         );
            //       },
            //     );
            //   }),
            // ),
            bottomView: ChatInputBoxView(
              allAtMap: logic.atUserNameMappingMap,
              controller: logic.inputCtrl,
              focusNode: logic.focusNode,
              isNotInGroup: logic.isInvalidGroup,
              onSend: (v) => logic.sendTextMsg(),
              sendAudio: logic.sendAudio,
              context: context,
              emojiBox:Container(
                color: Styles.c_F0F2F6,
                height: 224.h,
              ),
              toolbox: ChatToolBox(
                onTapAlbum: logic.onTapAlbum,
                onTapCamera: logic.onTapCamera,
                onTapCall: logic.call,
              ),
            ),
            child: ChatListView(
              itemCount: logic.messageList.length,
              controller: logic.scrollController,
              onScrollToBottomLoad: logic.onScrollToBottomLoad,
              onScrollToTop: logic.onScrollToTop,
              itemBuilder: (_, index) {
                final message = logic.indexOfMessage(index);
                return _buildItemView(message);
              },
            ),
          ),
        ));
  }
}
