import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privchat/pages/chat/group_setup/group_manage/group_manage_logic.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:sprintf/sprintf.dart';
import 'package:privchat/widgets/group_item_view.dart';

import 'group_setup_logic.dart';

class GroupSetupPage extends StatefulWidget {
  const GroupSetupPage({Key? key}) : super(key: key);

  @override
  _GroupSetupPageState createState() => _GroupSetupPageState();
}

class _GroupSetupPageState extends State<GroupSetupPage> {
  final logic = Get.find<GroupSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.groupChatSetup),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            if (logic.isJoinedGroup.value) _buildBaseInfoView(),
            if (logic.isJoinedGroup.value) _buildMemberView(),
            if (logic.isOwnerOrAdmin) _buildManageView(),
            10.verticalSpace,
            GroupItemView(
              children: [
                ItemView(
                  isFirstItem: true,
                  label: StrRes.topChat,
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
            if (!logic.isOwner)
            GroupItemView(
              children: [
                ItemView(
                  label: logic.isJoinedGroup.value
                      ? StrRes.exitGroup
                      : StrRes.delete,
                  textStyle: Styles.ts_FF381F_14sp,
                  showRightArrow: true,
                  onTap: logic.quitGroup,
                  isFirstItem: true,
                  isLastItem: true,
                ),
              ],
            ),
            if (logic.isOwner)
            GroupItemView(
              children: [
                ItemView(
                  label: StrRes.dismissGroup,
                  textStyle: Styles.ts_FF381F_14sp,
                  showRightArrow: true,
                  onTap: logic.quitGroup,
                  isFirstItem: true,
                  isLastItem: true,
                ),
              ],
            ),
            40.verticalSpace,
          ],
        ),
      )),
    );
  }

  Widget _buildBaseInfoView() => Container(
    height: 80.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 50.h,
          height: 50.h,
          child: Stack(
            children: [
              AvatarView(
                width: 48.w,
                height: 48.h,
                url: logic.groupInfo.value.faceURL,
                text: logic.groupInfo.value.groupName,
                textStyle: Styles.ts_FFFFFF_14sp,
                isGroup: true,
                onTap:
                    logic.isOwnerOrAdmin ? logic.modifyGroupAvatar : null,
              ),
              if (logic.isOwnerOrAdmin)
                Align(
                    alignment: Alignment.bottomRight,
                    child: ImageRes.editAvatar.toImage
                      ..width = 14.w
                      ..height = 14.h)
            ],
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: logic.isOwnerOrAdmin ? logic.modifyGroupName : null,
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150.w),
                      child: (logic.groupInfo.value.groupName ?? '').toText
                        ..style = Styles.ts_0C1C33_14sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ),
                    '(${logic.groupInfo.value.memberCount ?? 0})'.toText
                      ..style = Styles.ts_0C1C33_14sp,
                    6.horizontalSpace,
                    if (logic.isOwnerOrAdmin)
                      ImageRes.editName.toImage
                        ..width = 12.w
                        ..height = 12.h,
                  ],
                ),
              ),
              4.verticalSpace,
              logic.groupInfo.value.groupID.toText
                ..style = Styles.ts_8E9AB0_14sp
                ..onTap = logic.copyGroupID,
            ],
          ),
        ),
        ImageRes.mineQr.toImage
          ..width = 18.w
          ..height = 18.h
          ..onTap = logic.viewGroupQrcode,
      ],
    ),
  );

  Widget _buildMemberView() => Container(
    decoration: BoxDecoration(
      color: Styles.c_FFFFFF,
      borderRadius: BorderRadius.circular(6.r),
    ),
    margin: EdgeInsets.symmetric(horizontal: 10.w),
    child: Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: logic.viewGroupMembers,
          child: Container(
            padding: EdgeInsets.only(left: 12.w, right: 16.w),
            height: 46.h,
            child: Row(
              children: [
                sprintf(StrRes.viewAllGroupMembers,
                    [logic.groupInfo.value.memberCount]).toText
                  ..style = Styles.ts_0C1C33_14sp,
                const Spacer(),
                ImageRes.rightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h,
              ],
            ),
          ),
        ),
        Container(
          color: Styles.c_E8EAEF,
          height: 1,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logic.length(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 68.w / 78.h,
          ),
          itemBuilder: (BuildContext context, int index) {
            return logic.itemBuilder(
              index: index,
              builder: (info) => Column(
                children: [
                  SizedBox(
                    width: 58.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AvatarView(
                          width: 48.w,
                          height: 48.h,
                          url: info.faceURL,
                          text: info.nickname,
                          textStyle: Styles.ts_FFFFFF_14sp,
                          onTap: () => logic.viewMemberInfo(info),
                        ),
                        if (logic.groupInfo.value.ownerUserID ==
                            info.userID)
                          Positioned(
                            bottom: 0.h,
                            child: Container(
                              width: 52.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Styles.c_E8EAEF,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: StrRes.groupOwner.toText
                                ..style = Styles.ts_8E9AB0_10sp
                                ..maxLines = 1
                                ..overflow = TextOverflow.ellipsis,
                            ),
                          )
                      ],
                    ),
                  ),
                  2.verticalSpace,
                  (info.nickname ?? '').toText
                    ..style = Styles.ts_8E9AB0_10sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                ],
              ),
              addButton: () => GestureDetector(
                onTap: logic.addMember,
                child: Column(
                  children: [
                    ImageRes.addMember.toImage
                      ..width = 48.w
                      ..height = 48.h,
                    StrRes.addMember.toText..style = Styles.ts_8E9AB0_10sp,
                  ],
                ),
              ),
              delButton: () => GestureDetector(
                onTap: logic.removeMember,
                child: Column(
                  children: [
                    ImageRes.delMember.toImage
                      ..width = 48.w
                      ..height = 48.h,
                    StrRes.delMember.toText..style = Styles.ts_8E9AB0_10sp,
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );

  
  Widget _buildManageView() => Container(
    child: Column(
      children: [
        10.verticalSpace,
        GroupItemView(
          children: [
            ItemView(
              label: StrRes.groupAc,
              isFirstItem: true,
              showRightArrow: true,
            ),
            Divider(height: 1, color: Styles.c_E8EAEF, indent: 16.w),
            ItemView(
              label: StrRes.groupManage,
              isLastItem: true,
              showRightArrow: true,
              onTap: logic.manageGroup,
            ),
          ],
        ),
      ]
    ),
  );

}
