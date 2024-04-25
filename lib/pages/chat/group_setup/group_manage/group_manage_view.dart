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
    margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.muteAllMember,
          isBottomRadius: true,
          showSwitchButton: true,
        ),
      ]
    ),
  );
  
  Widget _buildGroupOptionView() => Container(
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.notAllowSeeMemberProfile,
          isBottomRadius: true,
          showSwitchButton: true,
        ),
        _buildItemView(
          text: StrRes.notAllAddMemberToBeFriend,
          isBottomRadius: true,
          showSwitchButton: true,
        ),
        _buildItemView(
          text: StrRes.joinGroupSet,
          isBottomRadius: true,
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
    margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
    child: Column(
      children: [
        _buildItemView(
          text: StrRes.transferGroupOwnerRight,
          isBottomRadius: true,
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
    bool isTopRadius = false,
    bool isBottomRadius = false,
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
              topRight: Radius.circular(isTopRadius ? 6.r : 0),
              topLeft: Radius.circular(isTopRadius ? 6.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
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
