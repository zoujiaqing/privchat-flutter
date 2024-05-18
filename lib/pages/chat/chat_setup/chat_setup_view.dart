import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';

import 'chat_setup_logic.dart';

class ChatSetupPage extends StatefulWidget {

  ChatSetupPage({super.key});
  
  @override
  _ChatSetupPageState createState() => _ChatSetupPageState();
}

class _ChatSetupPageState extends State<ChatSetupPage> {
  final logic = Get.find<ChatSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: [
                10.verticalSpace,

                GroupItemView(
                  children: [
                      _buildBaseInfoView(),
                    ]
                  ),
                10.verticalSpace,
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.topContacts,
                      showSwitchButton: true,
                      switchOn: logic.chatLogic.conversationInfo.value.isPinned!,
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (newValue) {
                        setState(() {
                          logic.chatLogic.setConversationTop(!logic.chatLogic.conversationInfo.value.isPinned!);
                        });
                      },
                      isFirstItem: true,
                    ),
                    Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
                    ItemView(
                      label: StrRes.messageNotDisturb,
                      isLastItem: true,
                      showSwitchButton: true,
                      switchOn: logic.chatLogic.conversationInfo.value.recvMsgOpt == 0 ? false : true,
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (newValue) {
                        setState(() {
                          logic.chatLogic.conversationInfo.value.recvMsgOpt = logic.chatLogic.conversationInfo.value.recvMsgOpt == 0 ? 1 : 0;
                          logic.chatLogic.setConversationDisturb(logic.chatLogic.conversationInfo.value.recvMsgOpt!);
                        });
                      }
                    ),
                  ],
                ),
                10.verticalSpace,
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.burnAfterReading,
                      isLastItem: true,
                      showSwitchButton: true,
                      isFirstItem: true,
                    ),
                  ],
                ),
                10.verticalSpace,
                GroupItemView(
                  children: [
                    ItemView(
                      label: StrRes.clearChatHistory,
                      textStyle: Styles.ts_FF381F_14sp,
                      isLastItem: true,
                      showRightArrow: true,
                      isFirstItem: true,
                      // onTap: logic.clearChatHistory,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildBaseInfoView() => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.viewUserInfo,
              child: SizedBox(
                width: 60.w,
                child: Column(
                  children: [
                    AvatarView(
                      width: 44.w,
                      height: 44.h,
                      text: logic.conversationInfo.value.showName,
                      url: logic.conversationInfo.value.faceURL,
                    ),
                    8.verticalSpace,
                    (logic.conversationInfo.value.showName ?? '').toText
                      ..style = Styles.ts_8E9AB0_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 60.w,
              child: Column(
                children: [
                  ImageRes.addFriendTobeGroup.toImage
                    ..width = 44.w
                    ..height = 44.h
                    ..onTap = logic.createGroup,
                  8.verticalSpace,
                  ''.toText
                    ..style = Styles.ts_8E9AB0_14sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                ],
              ),
            ),
          ],
        ),
      );

}
