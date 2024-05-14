import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_manage_logic.dart';

class GroupManagePage extends StatefulWidget {
  const GroupManagePage({Key? key}) : super(key: key);

  @override
  _GroupSetupPageState createState() => _GroupSetupPageState();
}

class _GroupSetupPageState extends State<GroupManagePage> {
  final logic = Get.find<GroupManageLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.groupChatSetup),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            _buildTalkView(),
            10.verticalSpace,
            _buildGroupOptionView(),
            10.verticalSpace,
            _buildManageView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTalkView() => Container(
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.muteAllMember,
          isLastItem: true,
          showSwitchButton: true,
          switchOn: logic.groupSetupLogic.groupInfo.value.status == 3,
          onTap: () {
            setState(() {});
          },
          onChanged: (newValue) {
            setState(() {
              logic.groupSetupLogic.groupInfo.value.status == newValue ? 3 : 0;
              logic.setGroupMute(newValue);
            });
          }
        ),
      ]
    ),
  );
  
  Widget _buildGroupOptionView() => Container(
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.notAllowSeeMemberProfile,
          isLastItem: true,
          showSwitchButton: true,
          switchOn: logic.groupSetupLogic.groupInfo.value.lookMemberInfo == 1 ? false : true,
          onTap: () {
            setState(() {});
          },
          onChanged: (newValue) {
            setState(() {
              logic.groupSetupLogic.groupInfo.value.lookMemberInfo == newValue ? 0 : 1;
              logic.setDisableViewMemberProfile(newValue);
            });
          }
        ),
        _buildItemView(
          text: StrRes.notAllAddMemberToBeFriend,
          isLastItem: true,
          showSwitchButton: true,
          switchOn: logic.groupSetupLogic.groupInfo.value.applyMemberFriend == 1 ? false : true,
          onTap: () {
            setState(() {});
          },
          onChanged: (newValue) {
            setState(() {
              logic.groupSetupLogic.groupInfo.value.applyMemberFriend == newValue ? 0 : 1;
              logic.setDisableMemberAddFriend(newValue);
            });
          }
        ),
        _buildItemView(
          text: StrRes.joinGroupSet,
          isLastItem: true,
          showRightArrow: true,
        ),
      ]
    ),
  );
  
  Widget _buildManageView() => Container(
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.transferGroupOwnerRight,
          isLastItem: true,
          showRightArrow: true,
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
