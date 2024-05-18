import 'package:flutter/material.dart';
import 'package:privchat/utils/int_ext.dart';
import 'package:privchat/widgets/chat_panel/AppWidget.dart';
import 'package:privchat/widgets/chat_panel/chat_audio_mask.dart';
import 'package:privchat/widgets/chat_panel/provider_chat_content.dart';
import 'package:privchat_common/privchat_common.dart';
import 'chat_input_box.dart';

class ChatBottom extends StatefulWidget {
  final ProviderChatContent providerChatContent;

  const ChatBottom({Key? key, required this.providerChatContent})
      : super(key: key);

  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> with WidgetsBindingObserver {
  // 0 语音 1 键盘 2 表情
  int _inputType = 0;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry? _overlayEntry = null;
  late OverlayState? _overlayState = null;

  bool get _keyboardShow => widget.providerChatContent.contentShow;

  RecordAudioState get _recordState =>
      widget.providerChatContent.recordAudioState;

  final List<Map> _listOption = [
    {'title': '相册', 'icon': 'assets/common/chat/ic_details_photo.webp'},
    {'title': '拍照', 'icon': 'assets/common/chat/ic_details_camera.webp'},
    {'title': '视频通话', 'icon': 'assets/common/chat/ic_details_video.webp'},
    {'title': '位置', 'icon': 'assets/common/chat/ic_details_localtion.webp'},
    {'title': '红包', 'icon': 'assets/common/chat/ic_details_red.webp'},
    {'title': '转账', 'icon': 'assets/common/chat/ic_details_transfer.webp'},
    // {'title': '语音输入', 'icon': 'assets/common/chat/ic_chat_voice.webp'},
    // {'title': '我的收藏', 'icon': 'assets/common/chat/ic_details_favorite.webp'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // debugPaintPointersEnabled = true;
    WidgetsBinding.instance.addObserver(this);
    _overlayState = Overlay.of(context);
    _controller.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.providerChatContent.updateContentShow(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.cale),
      decoration: BoxDecoration(
        color: Color(0xF7F7F7),
        border: Border(
          top: BorderSide(width: 1.cale, color: Color(0xffdddddd)),
        ),
      ),
      // height: 110.cale,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 20),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _inputType == 0
                    ? AppWidget.inkWellEffectNone(
                        key: const ValueKey("AppIcon.audio"),
                        onTap: () {
                          _inputType = 1;
                          print('启动音频 _inputType = 1');
                          widget.providerChatContent.updateContentShow(false);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20.cale, bottom: 15.cale),
                          child: Icon(
                            Icons.spatial_audio,
                            size: 50.cale,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : AppWidget.inkWellEffectNone(
                        key: const ValueKey("AppIcon.keyboard"),
                        onTap: () {
                          _inputType = 0;
                          widget.providerChatContent.updateContentShow(true);
                          print('启动键盘 _inputType = 0');
                          _focusNode.requestFocus();
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 20.cale, bottom: 15.cale),
                          child: Icon(
                            Icons.keyboard,
                            size: 50.cale,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: _inputType == 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.cale,
                        ),
                        child: ChatInputBox(
                          style:
                              TextStyle(fontSize: 30, color: Color(0x30000000)),
                          onEditingComplete: () {
                            print("onEditingComplete");
                          },
                          onSubmitted: (str) {
                            print("onSubmitted:$str");
                          },
                          controller: _controller,
                          focusNode: _focusNode,
                        ),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: (DragStartDetails details) {
                          print(
                              '-------------------------->onVerticalDragStart');
                          widget.providerChatContent.updateRecordAudioState(
                            RecordAudioState(recording: true,
                                recordingState: 1,
                                noticeMessage: StrRes.releaseToSend),
                          );
                          _showAudioRecord();
                        },
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          // print(
                          //     '-------------------------->onVerticalDragUpdate:${details.delta}');
                          // print(
                          //     '-------------------------->onVerticalDragUpdate:${details.localPosition.dy}');
                          // if (details.localPosition.dy > -20) {
                          //   widget.providerChatContent.updateRecordAudioState(
                          //     RecordAudioState(
                          //         recording: true,
                          //         recordingState: 1,
                          //         noticeMessage: StrRes.releaseToSend),
                          //   );
                          // } else {
                          //   widget.providerChatContent.updateRecordAudioState(
                          //     RecordAudioState(
                          //         recording: true,
                          //         recordingState: -1,
                          //         noticeMessage: StrRes.releaseToCancel),
                          //   );
                          // }
                          _updateAudioRecord();
                        },
                        onVerticalDragEnd: (DragEndDetails details) {
                          // print('-------------------------->onVerticalDragEnd');
                          _hideAudioRecord();
                          widget.providerChatContent.updateRecordAudioState(
                            RecordAudioState(
                                recording: false,
                                recordingState: 1,
                                noticeMessage: 'end'),
                          );
                        },
                        onVerticalDragCancel: () {
                          _hideAudioRecord();
                          widget.providerChatContent.updateRecordAudioState(
                            RecordAudioState(
                                recording: false,
                                recordingState: 1,
                                noticeMessage: 'cancel'),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.cale),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.cale),
                          ),
                          height: 80.cale,
                          child: Center(
                            child: StrRes.holdTalk.toText..style = Styles.ts_0089FF_22sp_semibold,
                          ),
                        ),
                      ),
              ),
              AppWidget.inkWellEffectNone(
                onTap: () {
                  print('添加表情符号');
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.cale),
                  child: Icon(
                    Icons.face,
                    size: 50.cale,
                    color: Colors.black,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    alignment: Alignment.centerRight,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: _inputType == 0 && _controller.value.text.isNotEmpty
                    ? AppWidget.inkWellEffectNone(
                        key: const ValueKey('发送'),
                        onTap: () {
                          print('发送');
                          _controller.clear();
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 20.cale, right: 24.cale, bottom: 10.cale),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.cale,
                            vertical: 10.cale,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff05C160),
                            borderRadius: BorderRadius.circular(12.cale),
                          ),
                          child: Center(
                              child: Text(
                            '发送',
                            style: TextStyle(
                                fontSize: 30, color: Color(0xff333333)),
                          )),
                        ),
                      )
                    : AppWidget.inkWellEffectNone(
                        key: const ValueKey('AppIcon.add'),
                        onTap: () {
                          print('添加附件 图片视频');
                          setState(() {
                            if (_focusNode.hasFocus) {
                              _focusNode.unfocus();
                            }
                            widget.providerChatContent.updateContentShow(true);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.cale, right: 20.cale, bottom: 10.cale),
                          child: Icon(
                            Icons.add,
                            size: 58.cale,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          if (_keyboardShow)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 20.cale,
              ),
              height:
                  widget.providerChatContent.keyboardHeight >= 0 ? 0 : 240.cale,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.cale, color: Color(0xffdddddd)),
                  ),
                ),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  //crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 150.cale,
                  runSpacing: 80.cale,
                  children: _listOption
                      .asMap()
                      .map(
                        (key, value) => MapEntry(
                          key,
                          SizedBox(
                            width: 100.cale,
                            height: 150.cale,
                            child: Column(
                              children: [
                                Container(
                                  width: 100.cale,
                                  height: 100.cale,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(25.cale),
                                  ),
                                  child: Image.asset(
                                    value['icon'],
                                    width: 50.cale,
                                    height: 50.cale,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.cale),
                                  child: Text(
                                    value['title'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }

  ///应用尺寸改变时回调，例如旋转 键盘
  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    if (mounted) {
      // 键盘高度
      final double viewInsetsBottom = EdgeInsets.fromWindowPadding(
              WidgetsBinding.instance.window.viewInsets,
              WidgetsBinding.instance.window.devicePixelRatio)
          .bottom;
      widget.providerChatContent.updateKeyboardHeight(viewInsetsBottom);
      // if (viewInsetsBottom > 0) {
      //   widget.providerChatContent.updateKeyboardHeight(viewInsetsBottom);
      // }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _showAudioRecord() {
    _hideAudioRecord();

    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return ChatAudioMask(recordAudioState: _recordState);
    });
    _overlayState!.insert(_overlayEntry!);
  }

  void _updateAudioRecord() {
    final overlayEntry = this._overlayEntry;
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  void _hideAudioRecord() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;

      if (_recordState.recording) {
        if (_recordState.recordingState == 1) {
          print("用户录音成功");
        } else {
          print("用户取消录音");
        }
      }
    }
  }
}
