import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat/widgets/group_item_view.dart';
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
      appBar: TitleBar.back(title: StrRes.groupManage),
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
    child: Column(
      children: [
        GroupItemView(
          children: [
            ItemView(
              label: StrRes.muteAllMember,
              isFirstItem: true,
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
          ],
        ),
      ]
    ),
  );
  
  Widget _buildGroupOptionView() => Container(
    child: Column(
      children: [

        GroupItemView(
          children: [
            ItemView(
              label: StrRes.notAllowSeeMemberProfile,
              isFirstItem: true,
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
            Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
            ItemView(
              label: StrRes.notAllAddMemberToBeFriend,
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
            Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
            ItemView(
              label: StrRes.joinGroupSet,
              showRightArrow: true,
            ),
            Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
            ItemView(
              label: StrRes.joinGroupSet,
              isLastItem: true,
              showRightArrow: true,
            ),
          ],
        ),
      ]
    ),
  );
  
  Widget _buildManageView() => Container(
    child: Column(
      children: [
        GroupItemView(
          children: [
            ItemView(
              label: StrRes.transferGroupOwnerRight,
              isFirstItem: true,
              isLastItem: true,
              showRightArrow: true,
            ),
          ],
        ),
      ]
    ),
  );

}
