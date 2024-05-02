import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:privchat/core/controller/im_controller.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sprintf/sprintf.dart';

import 'conversation_logic.dart';

class ConversationPage extends StatelessWidget {
  final logic = Get.find<ConversationLogic>();
  final im = Get.find<IMController>();

  ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Styles.c_FFFFFF,
          appBar: TitleBar.conversation(
              statusStr: logic.imSdkStatus,
              isFailed: logic.isFailedSdkStatus,
              popCtrl: logic.popCtrl,
              onScan: logic.scan,
              onAddFriend: logic.addFriend,
              onAddGroup: logic.addGroup,
              onCreateGroup: logic.createGroup,
              left: Expanded(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    StrRes.home.toText..style = Styles.ts_0C1C33_20sp_semibold,
                    10.horizontalSpace,
                    if (null != logic.imSdkStatus)
                      Flexible(
                          child: SyncStatusView(
                        isFailed: logic.isFailedSdkStatus,
                        statusStr: logic.imSdkStatus!,
                      )),
                  ],
                ),
              )),
          body: Column(
            children: [
              Expanded(
                child: SlidableAutoCloseBehavior(
                  child: SmartRefresher(
                    controller: logic.refreshController,
                    header: IMViews.buildHeader(),
                    footer: IMViews.buildFooter(),
                    enablePullUp: true,
                    enablePullDown: true,
                    onRefresh: logic.onRefresh,
                    onLoading: logic.onLoading,
                    child: ListView.builder(
                      itemCount: logic.list.length,
                      controller: logic.scrollController,
                      itemBuilder: (_, index) => AutoScrollTag(
                        key: ValueKey(index),
                        controller: logic.scrollController,
                        index: index,
                        child: _buildConversationItemView(
                          logic.list.elementAt(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildConversationItemView(ConversationInfo info) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: logic.existUnreadMsg(info) ? 0.7 : (logic.isPinned(info) ? 0.5 : 0.4),
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.pinConversation(info),
              flex: logic.isPinned(info) ? 3 : 2,
              backgroundColor: Styles.c_0089FF,
              padding: const EdgeInsets.all(1),
              child: (logic.isPinned(info) ? StrRes.cancelTop : StrRes.top).toText..style = Styles.ts_FFFFFF_14sp,
            ),
            if (logic.existUnreadMsg(info))
              CustomSlidableAction(
                onPressed: (_) => logic.markMessageHasRead(info),
                flex: 3,
                backgroundColor: Styles.c_8E9AB0,
                padding: const EdgeInsets.all(1),
                child: StrRes.markHasRead.toText
                  ..style = Styles.ts_FFFFFF_14sp
                  ..maxLines = 1,
              ),
            CustomSlidableAction(
              onPressed: (_) => logic.deleteConversation(info),
              flex: 2,
              backgroundColor: Styles.c_FF381F,
              padding: const EdgeInsets.all(1),
              child: StrRes.delete.toText..style = Styles.ts_FFFFFF_14sp,
            ),
          ],
        ),
        child: Column(
            children: [
              _buildItemView(info),
              Divider(height: 1, color: Styles.c_E8EAEF, indent: 72.w),
            ],
          )
      );

  Widget _buildItemView(ConversationInfo info) => Ink(
        child: InkWell(
          onTap: () => logic.toChat(conversationInfo: info),
          child: Stack(
            children: [
              Container(
                height: 58.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    AvatarView(
                      width: 42.w,
                      height: 42.h,
                      text: logic.getShowName(info),
                      url: info.faceURL,
                      isGroup: logic.isGroupChat(info),
                      textStyle: Styles.ts_FFFFFF_14sp_medium,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 180.w),
                                child: logic.getShowName(info).toText
                                  ..style = Styles.ts_0C1C33_14sp
                                  ..maxLines = 1
                                  ..overflow = TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              logic.getTime(info).toText..style = Styles.ts_8E9AB0_12sp,
                            ],
                          ),
                          3.verticalSpace,
                          Row(
                            children: [
                              MatchTextView(
                                text: logic.getContent(info),
                                textStyle: Styles.ts_8E9AB0_14sp,
                                allAtMap: logic.getAtUserMap(info),
                                prefixSpan: TextSpan(
                                  text: '',
                                  children: [
                                    if (logic.isNotDisturb(info) && logic.getUnreadCount(info) > 0)
                                      TextSpan(
                                        text: '[${sprintf(StrRes.nPieces, [logic.getUnreadCount(info)])}] ',
                                        style: Styles.ts_8E9AB0_14sp,
                                      ),
                                    TextSpan(
                                      text: logic.getPrefixTag(info),
                                      style: Styles.ts_0089FF_14sp,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                patterns: <MatchPattern>[
                                  MatchPattern(
                                    type: PatternType.at,
                                    style: Styles.ts_8E9AB0_14sp,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (logic.isNotDisturb(info))
                                ImageRes.notDisturb.toImage
                                  ..width = 13.63.w
                                  ..height = 14.07.h
                              else
                                UnreadCountView(count: logic.getUnreadCount(info)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (logic.isPinned(info))
                Container(
                  height: 58.h,
                  margin: EdgeInsets.only(right: 16.w),
                  foregroundDecoration: RotatedCornerDecoration.withColor(
                    color: Styles.c_0089FF,
                    badgeSize: Size(10.w, 10.h),
                  ),
                ),
            ],
          ),
        ),
      );
}
