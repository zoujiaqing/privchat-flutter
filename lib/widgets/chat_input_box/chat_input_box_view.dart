import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat_common/src/widgets/chat/chat_disable_input_box.dart';
import 'package:privchat/utils/int_ext.dart';
import 'chat_input_box_logic.dart';
import 'dart:io';



double kInputBoxMinHeight = 56.h;

typedef SendAudioCallBack = Function(String path, int duration);
typedef clickEmojiCallBack = Function();

class ChatInputBoxView extends StatelessWidget {
  final state = Get.find<ChatInputBoxLogic>().state;
  final logic = ChatInputBoxLogic();

  final AtTextCallback? atCallback;
  final SendAudioCallBack? sendAudio;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final TextStyle? atStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isMultiModel;
  final bool isNotInGroup;
  final String? hintText;
  final Widget toolbox;
  final Widget? emojiBox;
  final ValueChanged<String>? onSend;
  var replyMsg = "".obs;
  BuildContext? context;

  ChatInputBoxView({
    required this.toolbox,
    this.emojiBox,
    this.allAtMap = const {},
    this.atCallback,
    this.sendAudio,
    this.controller,
    this.focusNode,
    this.style,
    this.atStyle,
    this.inputFormatters,
    this.enabled = true,
    this.isMultiModel = false,
    this.isNotInGroup = false,
    this.hintText,
    this.onSend,
    required this.replyMsg,
    this.context,
  }){
    print("LTTTTTT:构造函数init：${this.controller}");
    // state.controller = this.controller!;
    state.atCallback = this.atCallback;
    state.sendAudio = this.sendAudio;
    state.allAtMap = this.allAtMap;
    state.focusNode = this.focusNode!;
    state.style = this.style;
    state.atStyle = this.atStyle;
    state.inputFormatters = this.inputFormatters;
    state.enabled = this.enabled;
    state.isMultiModel = this.isMultiModel;
    state.isNotInGroup = this.isNotInGroup;
    state.hintText = this.hintText;
    state.toolbox = this.toolbox;
    state.emojiBox = this.emojiBox;
    state.context = this.context;
    state.onSend = this.onSend;
    state.replyMsg = this.replyMsg.value;
    state.replyAction(this.replyMsg.value);
    state.setController(this.controller!);
  }

  double get _opacity => (state.enabled ? 1 : .4);

  @override
  Widget build(BuildContext context) {
    double bottomPadding = 0;
    if (Platform.isIOS) {
      bottomPadding = 16.h;
    } else {
      bottomPadding = 16.h;
    }

    if (!state.enabled) state.controller!.clear();
    return GetBuilder<ChatInputBoxLogic>(builder: (logic) {
      return state.isNotInGroup
          ? const ChatDisableInputBox()
          : state.isMultiModel
              ? const SizedBox()
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      constraints:
                          BoxConstraints(minHeight: kInputBoxMinHeight),
                      color: Styles.c_F0F2F6,
                      child: Row(
                        children: [
                          12.horizontalSpace,
                          GestureDetector(
                            onTap: () => logic.switchToVoice(),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                state.voiceMode
                                    ? Icons.keyboard
                                    : Icons.multitrack_audio_outlined,
                                size: 30.cale,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                              child: state.voiceMode
                                  ? _voiceButton(logic)
                                  : _textFiled),
                          12.horizontalSpace,
                          GestureDetector(
                              onTap: () => logic.changeButton(),
                              child: Icon(
                                state.emojiVisible
                                    ? Icons.keyboard
                                    : Icons.emoji_emotions_outlined,
                                color: Colors.black,
                                size: 40,
                              )),
                          12.horizontalSpace,
                          (state.sendButtonVisible
                                  ? ImageRes.sendMessage
                                  : ImageRes.openToolbox)
                              .toImage
                            ..width = 32.w
                            ..height = 32.h
                            ..opacity = _opacity
                            ..onTap = state.sendButtonVisible
                                ? logic.send
                                : logic.toggleToolbox,
                          12.horizontalSpace,
                        ],
                      ),
                    ),
                    Visibility(
                      visible: state.toolsVisible,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 200),
                        child: state.toolbox!,
                      ),
                    ),
                    Visibility(
                      visible: state.emojiVisible,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 200),
                        child: state.emojiBox ?? Container(),
                      ),
                    ),
                  ],
                );
    });
  }

  Widget _voiceButton(ChatInputBoxLogic logic) {
    print("click _voiceButton");
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (DragStartDetails details) =>
          logic.voiceButtonDragStart(details),
      onVerticalDragUpdate: (DragUpdateDetails details) =>
          logic.voiceButtonDragUpdate(details),
      onVerticalDragEnd: (DragEndDetails details) =>
          logic.voiceButtonDragEnd(details),
      onVerticalDragCancel: () => logic.voiceButtonDragCancel(),
      child: Container(
        height: 62.h,
        child: Center(
          child: Text(
            state.isRecording ? StrRes.releaseToSend : StrRes.holdTalk,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget get _textFiled {
    return Container(
        margin: EdgeInsets.all(10.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Styles.c_FFFFFF,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ChatTextField(
                allAtMap: state.allAtMap,
                atCallback: state.atCallback,
                controller: state.controller,
                focusNode: state.focusNode,
                style: state.style ?? Styles.ts_0C1C33_17sp,
                atStyle: state.atStyle ?? Styles.ts_0089FF_17sp,
                inputFormatters: state.inputFormatters,
                enabled: state.enabled,
                hintText: state.hintText,
                textAlign: state.enabled ? TextAlign.start : TextAlign.center,
              ),
            ),
            _transfer,
          ],
        ),
    );
  }

  Widget get _transfer {
    if (state.replyMsg != "") {
      return Container(
        margin: EdgeInsets.only(top: 4.h),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _transfermsg,
            ),
            GestureDetector(
              onTap: () {
                // Handle the tap event to remove or hide the reference text
                replyMsg.value = "";
                print("33333333333");
              },
              child: Icon(
                Icons.close,
                size: 14.w,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget get _transfermsg {

    return Container(
       child: Text(state.replyMsg!),
    );
  }


}
