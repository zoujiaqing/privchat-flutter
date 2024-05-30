import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:star_menu/star_menu.dart';

double maxWidth = 247.w;
double pictureWidth = 120.w;
double videoWidth = 120.w;
double locationWidth = 220.w;

BorderRadius borderRadius(bool isISend) => BorderRadius.only(
      topLeft: Radius.circular(isISend ? 6.r : 0),
      topRight: Radius.circular(isISend ? 0 : 6.r),
      bottomLeft: Radius.circular(6.r),
      bottomRight: Radius.circular(6.r),
    );

class MsgStreamEv<T> {
  final String id;
  final T value;

  MsgStreamEv({required this.id, required this.value});

  @override
  String toString() {
    return 'MsgStreamEv{msgId: $id, value: $value}';
  }
}

class CustomTypeInfo {
  final Widget customView;
  final bool needBubbleBackground;
  final bool needChatItemContainer;

  CustomTypeInfo(
    this.customView, [
    this.needBubbleBackground = true,
    this.needChatItemContainer = true,
  ]);
}

typedef CustomTypeBuilder = CustomTypeInfo? Function(
  BuildContext context,
  Message message,
);
typedef NotificationTypeBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemViewBuilder = Widget? Function(
  BuildContext context,
  Message message,
);
typedef ItemVisibilityChange = void Function(
  Message message,
  bool visible,
);

class ChatItemView extends StatefulWidget {
  const ChatItemView({
    Key? key,
    this.itemViewBuilder,
    this.customTypeBuilder,
    this.notificationTypeBuilder,
    this.sendStatusSubject,
    this.sendProgressSubject,
    this.timelineStr,
    this.leftNickname,
    this.leftFaceUrl,
    this.rightNickname,
    this.rightFaceUrl,
    required this.message,
    this.textScaleFactor = 1.0,
    this.ignorePointer = false,
    this.showLeftNickname = true,
    this.showRightNickname = false,
    this.highlightColor,
    this.allAtMap = const {},
    this.patterns = const [],
    this.onTapLeftAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onLongPressRightAvatar,
    this.onVisibleTrulyText,
    this.onFailedToResend,
    this.onClickItemView,
    this.onClickMenuTapItem,
  }) : super(key: key);

  final ItemViewBuilder? itemViewBuilder;
  final CustomTypeBuilder? customTypeBuilder;
  final NotificationTypeBuilder? notificationTypeBuilder;
  final Subject<MsgStreamEv<bool>>? sendStatusSubject;
  final Subject<MsgStreamEv<int>>? sendProgressSubject;
  final String? timelineStr;
  final String? leftNickname;
  final String? leftFaceUrl;
  final String? rightNickname;
  final String? rightFaceUrl;
  final Message message;

  final double textScaleFactor;

  final bool ignorePointer;
  final bool showLeftNickname;
  final bool showRightNickname;

  final Color? highlightColor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final Function()? onTapLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onLongPressRightAvatar;
  final Function(String? text)? onVisibleTrulyText;
  final Function()? onClickItemView;
  final Function(int index, StarMenuController controller)? onClickMenuTapItem;

  final Function()? onFailedToResend;

  @override
  State<ChatItemView> createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  Message get _message => widget.message;

  bool get _isISend => _message.sendID == OpenIM.iMManager.userID;

  late StreamSubscription<bool> _keyboardSubs;

  @override
  void dispose() {
    _keyboardSubs.cancel();
    super.dispose();
  }

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();

    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: Container(
        color: widget.highlightColor,
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Center(child: _child),
      ),
      onVisibilityLost: () {},
      onVisibilityGained: () {},
    );
  }

  Widget get _child => widget.itemViewBuilder?.call(context, _message) ?? _buildChildView();

  Widget _buildChildView() {
    Widget? child;
    Widget? queueChild;
    Widget? childStatusItem;
    String? senderNickname;
    String? senderFaceURL;
    bool isBubbleBg = false;

    final chatItemStarMenuController = StarMenuController();
    Function(int index, StarMenuController controller)? func = widget.onClickMenuTapItem;

    // entries for the dropdown menu
    final upperMenuItems = <Widget>[
      const Text('复制'),
      const Text('回复'),
      const Text('撤销'),
      const Text('删除'),
      const Text('转发'),
    ];
    print("contentType:${_message.soundElem?.duration ?? 1}");
    if (_message.isTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.textElem!.content!,
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
    }
    if (_message.isVoiceType) {
      isBubbleBg = true;
      double voiceWidth = 0;
      if(_message.soundElem?.duration != null){
        int duration = _message.soundElem!.duration!;
        if(duration < 10){
          voiceWidth = 50.w;
        } else if (duration < 30) {
          voiceWidth = 100.w;
        } else {
          voiceWidth = 150.w;
        }
        child = Container(
          constraints: BoxConstraints(maxWidth: voiceWidth),
          child: Row(
            children: [
              Icon(Icons.record_voice_over_outlined,size: 15,),
              10.horizontalSpace,
              Text("${_message.soundElem?.duration??0}″"),
            ],
          ),
        );
      }
      if (!_isISend) {
        // TODO: if unread show it
        childStatusItem = _buildUnreadVoiceIcon();
      }
    } else if (_message.isAtTextType) {
      isBubbleBg = true;
      child = ChatText(
        text: _message.atTextElem!.text!,
        allAtMap: IMUtils.getAtMapping(_message, widget.allAtMap),
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
    } else if (_message.isPictureType) {
      child = ChatPictureView(
        isISend: _isISend,
        message: _message,
        sendProgressStream: widget.sendProgressSubject,
      );
    } else if (_message.isVideoType) {
      final video = _message.videoElem;
      child = ChatVideoView(
        isISend: _isISend,
        message: _message,
        sendProgressStream: widget.sendProgressSubject,
      );
    } else if (_message.isQuoteType) {
      final queueMsg = _message.quoteElem;
      isBubbleBg = true;
      child = ChatText(
        text: queueMsg!.text!,
        patterns: widget.patterns,
        textScaleFactor: widget.textScaleFactor,
        onVisibleTrulyText: widget.onVisibleTrulyText,
      );
      queueChild = _buildQueueChild(queueMsg.quoteMessage!);
    } else if (_message.isCustomType) {
      final info = widget.customTypeBuilder?.call(context, _message);
      if (null != info) {
        isBubbleBg = info.needBubbleBackground;
        child = info.customView;
        if (!info.needChatItemContainer) {
          return child;
        }
      }
    } else if (_message.isNotificationType) {
      if (_message.contentType ==
          MessageType.groupInfoSetAnnouncementNotification) {
      } else {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ChatHintTextView(message: _message),
        );
      }
    }
    senderNickname ??= widget.leftNickname ?? _message.senderNickname;
    senderFaceURL ??= widget.leftFaceUrl ?? _message.senderFaceUrl;

    // My send message status
    if (_isISend) {
      childStatusItem = _buildStatusIcon(_message.isRead! ? MessageStatus.read : _message.status!);
    }

    return child = ChatItemContainer(
      id: _message.clientMsgID!,
      isISend: _isISend,
      leftNickname: senderNickname,
      leftFaceUrl: senderFaceURL,
      rightNickname: widget.rightNickname ?? OpenIM.iMManager.userInfo.nickname,
      rightFaceUrl: widget.rightFaceUrl ?? OpenIM.iMManager.userInfo.faceURL,
      showLeftNickname: widget.showLeftNickname,
      showRightNickname: widget.showRightNickname,
      timelineStr: widget.timelineStr,
      timeStr: IMUtils.getChatTimeline(_message.sendTime!, 'HH:mm:ss'),
      isSending: _message.status == MessageStatus.sending,
      isSendFailed: _message.status == MessageStatus.failed,
      isBubbleBg: child == null ? true : isBubbleBg,
      ignorePointer: widget.ignorePointer,
      sendStatusStream: widget.sendStatusSubject,
      onFailedToResend: widget.onFailedToResend,
      onLongPressLeftAvatar: widget.onLongPressLeftAvatar,
      onLongPressRightAvatar: widget.onLongPressRightAvatar,
      onTapLeftAvatar: widget.onTapLeftAvatar,
      onTapRightAvatar: widget.onTapRightAvatar,
      onClickMenuTapItem: widget.onClickMenuTapItem,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onClickItemView,
        child: child ?? ChatText(text: StrRes.unsupportedMessage),
      ),
      queueChild: queueChild,
      childStatusIcon: childStatusItem,
    ).addStarMenu(
      items: upperMenuItems,
      params: StarMenuParameters.dropdown(context).copyWith(
          backgroundParams: const BackgroundParams().copyWith(
            sigmaX: 3,
            sigmaY: 3,
          ),
          shape: MenuShape.linear,
          useTouchAsCenter: true,
          useLongPress: true),
      controller: chatItemStarMenuController,
      onItemTapped: func,
    );
  }

  Widget _buildUnreadVoiceIcon() {
    return Icon(
      Icons.circle,
      color: Colors.redAccent,
      size: 8,
    );
  }

  Widget _buildQueueChild(Message message) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Styles.c_F4F5F7,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${message.senderNickname}${StrRes.colon}',
            style: Styles.ts_8E9AB0_12sp,
          ),
          4.horizontalSpace,
          // TODO: 这个 Text("应用原文") 要改成一个build，可以显示图片或文字
          Text(
            "引用原文",
            style: Styles.ts_8E9AB0_12sp,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(int status) {
    IconData iconData;
    Color color;

    switch (status) {
      case MessageStatus.sending:
        iconData = Icons.access_time;
        color = Colors.blue;
        break;
      case MessageStatus.succeeded:
        iconData = Icons.check;
        color = Colors.blue;
        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        color = Colors.green;
        break;
      case MessageStatus.failed:
        iconData = Icons.error;
        color = Colors.red;
        break;
      default:
        iconData = Icons.access_time;
        color = Colors.blue;
    }

    return Icon(
      iconData,
      color: color,
      size: 18,
    );
  }
}
