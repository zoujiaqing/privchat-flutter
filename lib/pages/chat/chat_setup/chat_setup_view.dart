import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';

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
                _buildBaseInfoView(),
                _buildChatOptionView(),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.burnAfterReading,
                  isLastItem: true,
                  // onTap: logic.clearChatHistory,
                  showSwitchButton: true
                ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.clearChatHistory,
                  textStyle: Styles.ts_FF381F_17sp,
                  // onTap: logic.clearChatHistory,
                  showRightArrow: true,
                  isLastItem: true,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildBaseInfoView() => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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


Widget _buildChatOptionView() => Container(
  decoration: BoxDecoration(
    color: Styles.c_FFFFFF,
    borderRadius: BorderRadius.circular(6.r),
  ),
  margin: EdgeInsets.symmetric(vertical: 0.h),
  child: Column(
    children: [
      _buildItemView(
        text: StrRes.topContacts,
        isLastItem: true,
        showSwitchButton: true,
        switchOn: logic.chatLogic.conversationInfo.value.isPinned!,
        onTap: () {
          setState(() {});
        },
        onChanged: (newValue) {
          setState(() {
            logic.chatLogic.setConversationTop(!logic.chatLogic.conversationInfo.value.isPinned!);
          });
        }
      ),
      _buildItemView(
        text: StrRes.messageNotDisturb,
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
    ]
  ),
);

Widget _buildItemView({
  required String text,
  TextStyle? textStyle,
  String? value,
  bool switchOn = false,
  bool isFirstItem = false,
  bool isLastItem = false,
  bool showRightArrow = false,
  bool showSwitchButton = false,
  ValueChanged<bool>? onChanged,
  Function()? onTap,
}) =>
  GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.translucent,
    child: Container(
      height: 46.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(isFirstItem ? 10.r : 0),
          topLeft: Radius.circular(isFirstItem ? 10.r : 0),
          bottomLeft: Radius.circular(isLastItem ? 10.r : 0),
          bottomRight: Radius.circular(isLastItem ? 10.r : 0),
        ),
      ),
      child: Row(
        children: [
          text.toText..style = textStyle ?? Styles.ts_0C1C33_17sp,
          const Spacer(),
          if (null != value) value.toText..style = Styles.ts_8E9AB0_14sp,
          if (showSwitchButton)
            CupertinoSwitch(
              value: switchOn,
              activeColor: Styles.c_0089FF,
              onChanged: onChanged,
            ),
          if (showRightArrow)
            ImageRes.rightArrow.toImage
              ..width = 24.w
              ..height = 24.h,
        ],
      ),
    ),
  );
}
