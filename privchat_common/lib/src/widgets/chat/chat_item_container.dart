import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:star_menu/star_menu.dart';

class ChatItemContainer extends StatelessWidget {
  const ChatItemContainer({
    Key? key,
    required this.id,
    this.leftFaceUrl,
    this.rightFaceUrl,
    this.leftNickname,
    this.rightNickname,
    this.timelineStr,
    this.timeStr,
    required this.isBubbleBg,
    required this.isISend,
    required this.isSending,
    required this.isSendFailed,
    this.ignorePointer = false,
    this.showLeftNickname = true,
    this.showRightNickname = false,
    required this.child,
    required this.childStatusIcon,
    this.sendStatusStream,
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onFailedToResend,
    this.onClickMenuTapItem,
  }) : super(key: key);
  final String id;
  final String? leftFaceUrl;
  final String? rightFaceUrl;
  final String? leftNickname;
  final String? rightNickname;
  final String? timelineStr;
  final String? timeStr;
  final bool isBubbleBg;
  final bool isISend;
  final bool isSending;
  final bool isSendFailed;
  final bool ignorePointer;
  final bool showLeftNickname;
  final bool showRightNickname;
  final Widget child;
  final Widget? childStatusIcon;
  final Stream<MsgStreamEv<bool>>? sendStatusStream;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function()? onFailedToResend;
  final Function(int index, StarMenuController controller)? onClickMenuTapItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: ignorePointer,
        child: Column(
          children: [
            if (null != timelineStr)
              ChatTimelineView(
                timeStr: timelineStr!,
                margin: EdgeInsets.only(bottom: 20.h),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: isISend ? _buildRightView() : _buildLeftView()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildView(BubbleType type) =>
      isBubbleBg ? ChatBubble(bubbleType: type, child: child) : child;

  Widget _buildLeftView() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AvatarView(
            width: 44.w,
            height: 44.h,
            textStyle: Styles.ts_FFFFFF_14sp_medium,
            url: leftFaceUrl,
            text: leftNickname,
            onTap: onTapLeftAvatar,
            onLongPress: onLongPressLeftAvatar,
          ),
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChatNicknameView(
                nickname: showLeftNickname ? leftNickname : null,
                timeStr: timeStr,
              ),
              4.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildChildView(BubbleType.receiver),
                  4.horizontalSpace,
                  if (childStatusIcon != null) childStatusIcon!,
                ],
              ),
            ],
          ),
        ],
      );

  Widget _buildRightView() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChatNicknameView(
                nickname: showRightNickname ? rightNickname : null,
                timeStr: timeStr,
              ),
              4.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (childStatusIcon != null) childStatusIcon!,
                  4.horizontalSpace,
                  _buildChildView(BubbleType.send),
                ],
              ),
            ],
          ),
          10.horizontalSpace,
          AvatarView(
            width: 44.w,
            height: 44.h,
            textStyle: Styles.ts_FFFFFF_14sp_medium,
            url: rightFaceUrl,
            text: rightNickname,
            onTap: onTapRightAvatar,
            onLongPress: onLongPressRightAvatar,
          ),
        ],
      );
}
