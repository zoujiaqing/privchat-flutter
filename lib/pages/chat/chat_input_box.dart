import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat_common/src/utils/event_bus_utils.dart';
import 'package:privchat_common/src/widgets/chat/chat_disable_input_box.dart';
import 'package:privchat/utils/int_ext.dart';
import 'package:privchat/widgets/chat_panel/chat_audio_mask.dart';
import 'package:privchat/widgets/chat_panel/provider_chat_content.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';


double kInputBoxMinHeight = 56.h;
typedef SendAudioCallBack = Function(String path, int duration);
typedef clickEmojiCallBack = Function();

class ChatInputBox extends StatefulWidget {
  const ChatInputBox({
    Key? key,
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
  }) : super(key: key);
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

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}


class HideBottomEvent{}

class _ChatInputBoxState extends State<ChatInputBox> {
  // 这个值可以根据 conversationId 记录下来状态
  bool _voiceMode = false;
  bool _toolsVisible = false;
  bool _emojiVisible = false;
  bool _sendButtonVisible = false;

  double get _opacity => (widget.enabled ? 1 : .4);

  @override
  void initState() {
    initRecord();
    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _toolsVisible = false;
          _emojiVisible = false;
        });
      }
    });

    widget.controller?.addListener(() {
      setState(() {
        _sendButtonVisible = widget.controller!.text.isNotEmpty;
      });
    });
    _overlayState = Overlay.of(context);
    super.initState();
    eventBus.on<HideBottomEvent>().listen((event) {
      unfocus();
      setState(() {
        _toolsVisible = false;
        _emojiVisible = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopRecorder();
    _mRecorder!.closeRecorder();
    _mRecorder = null;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) widget.controller?.clear();
    return widget.isNotInGroup
        ? const ChatDisableInputBox()
        : widget.isMultiModel
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    constraints: BoxConstraints(minHeight: kInputBoxMinHeight),
                    color: Styles.c_F0F2F6,
                    child: Row(
                      children: [
                        12.horizontalSpace,

                        GestureDetector(onTap: (){
                          setState(() {
                            _voiceMode = !_voiceMode;
                            _toolsVisible = false;
                            _emojiVisible = false;
                            // focus 了为啥不弹出键盘？
                            _voiceMode ? unfocus() : focus();
                          });
                        },
                        child: Padding(
                          padding:
                          EdgeInsets.all(10),
                          child: Icon(
                            _voiceMode ? Icons.keyboard : Icons.multitrack_audio_outlined,
                            size: 30.cale,
                            color: Colors.black,
                          ),
                        ),
                        ),
                        Expanded(
                          child: _voiceMode ? _voiceButton() : _textFiled
                        ),
                        12.horizontalSpace,
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _emojiVisible = !_emojiVisible;
                              _toolsVisible = false;
                              _voiceMode = false;
                              _emojiVisible ? unfocus() : focus();
                            });
                          },
                          child: Icon(
                            _emojiVisible ? Icons.keyboard : Icons.emoji_emotions_outlined,
                            color: Colors.black,
                            size: 40,
                          )
                        ),
                        12.horizontalSpace,
                        (_sendButtonVisible
                                ? ImageRes.sendMessage
                                : ImageRes.openToolbox)
                            .toImage
                          ..width = 32.w
                          ..height = 32.h
                          ..opacity = _opacity
                          ..onTap = _sendButtonVisible ? send : toggleToolbox,
                        12.horizontalSpace,
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _toolsVisible,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: widget.toolbox,
                    ),
                  ),
                  Visibility(
                    visible: _emojiVisible,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: widget.emojiBox??Container(),
                    ),
                  ),
                ],
              );
  }

  Widget get _textFiled => Container(
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: ChatTextField(
          allAtMap: widget.allAtMap,
          atCallback: widget.atCallback,
          controller: widget.controller,
          focusNode: widget.focusNode,
          style: widget.style ?? Styles.ts_0C1C33_17sp,
          atStyle: widget.atStyle ?? Styles.ts_0089FF_17sp,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          hintText: widget.hintText,
          textAlign: widget.enabled ? TextAlign.start : TextAlign.center,
        ),
      );

  void send() {
    if (!widget.enabled) return;
    if (!_emojiVisible) focus();
    if (null != widget.onSend && null != widget.controller) {
      widget.onSend!(widget.controller!.text.toString().trim());
    }
  }

  void toggleToolbox() {
    if (!widget.enabled) return;
    setState(() {
      _toolsVisible = !_toolsVisible;
      _emojiVisible = false;
      _voiceMode = false;
      // _leftKeyboardButton = true;
      if (_toolsVisible) {
        unfocus();
      } else {
        focus();
      }
    });
  }


  void onTapRightKeyboard() {
    if (!widget.enabled) return;
    setState(() {
      _toolsVisible = false;
      _emojiVisible = false;
      focus();
    });
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());

  bool isRecording = false;
  late OverlayEntry? _overlayEntry = null;
  late OverlayState? _overlayState = null;
  StreamSubscription? _mRecordingDataSubscription;
  RecordAudioState _recordState = RecordAudioState(
    recording: false,
    recordingState: -1,
    noticeMessage: 'init',
  );
  Timer ? _cancelAndRestartTimer;
  int duration = 0;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mplaybackReady = false;
  String? _mPath;
  bool _mRecorderIsInited = false;
  int tSampleRate = 44000;
  bool _mEnableVoiceProcessing = false;
  initRecord() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    _mRecorderIsInited = true;
  }

  Future<IOSink> createFile() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_audio.opus';
    var outputFile = File(_mPath!);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }
  Future<void> record() async {
    assert(_mRecorderIsInited);
    // assert(_mRecorderIsInited && _mPlayer!.isStopped);
    var sink = await createFile();
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            sink.add(buffer.data!);
          }
        });

    await _mRecorder!.startRecorder(
        toStream: recordingDataController.sink,
        codec: Codec.opusWebM,
        numChannels: 1,
        sampleRate: tSampleRate,
        enableVoiceProcessing: _mEnableVoiceProcessing
    );

    _cancelAndRestartTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      duration+=1;
    });
    setState(() {});
  }
  Future<void> stopRecorder() async {
    _cancelAndRestartTimer?.cancel();
    await _mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    _mplaybackReady = true;
  }

  void _showAudioRecord() {
    _startRecordingTimer();
    // _hideAudioRecord();
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return ChatAudioMask(recordAudioState: _recordState);
    });
    _overlayState!.insert(_overlayEntry!);
    record();
  }

  void _startRecordingTimer() {
    Timer(Duration(seconds: 10), () {
      if (_recordState.recording) {
        _onRecordingEnd();
      }
    });
  }

  Future<void> _hideAudioRecord() async {
    print("_hideAudioRecord 1  ${_recordState.noticeMessage}");
    if (_overlayEntry != null) {
      print("_hideAudioRecord 2");
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (_recordState.recording) {
        await stopRecorder();
        print("_hideAudioRecord 3  duration:${duration}");
        if (_recordState.recordingState == 1 &&_recordState.noticeMessage!="松开 取消" && duration > 1) {
          print("_hideAudioRecord 4  ${_recordState.recordingState}");
          widget.sendAudio?.call(_mPath!,duration);
          updateRecordAudioState(RecordAudioState(recording: false, recordingState: -1, noticeMessage: ''));
          print("用户录音成功");
        } else {
          print("用户取消录音");
        }
        duration=0;
      }
    }
  }
  void _updateAudioRecord() {
    final overlayEntry = this._overlayEntry;
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }
  void updateRecordAudioState(RecordAudioState state) {
    _recordState = state;
    print("updateRecordAudioState_${_recordState.recordingState}");
    setState(() {
    });
  }

  Widget _voiceButton() {
    bool isCancel = false;
    Timer? _pressTimer;

    void _startPressTimer() {
      _pressTimer = Timer(Duration(milliseconds: 100), () {
        _showRecordingOverlay();
      });
    }

    void _cancelPressTimer() {
      _pressTimer?.cancel();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (DragStartDetails details) {
        if (isRecording) {
          return; // 如果正在录制，则直接返回，避免重复启动 Timer
        }
        setState(() {
          isRecording = true;
        });
        updateRecordAudioState(
          RecordAudioState(
              recording: true,
              recordingState: 1,
              noticeMessage: StrRes.releaseToSend,
            ),
        );
        _startPressTimer();
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.localPosition.dy > -80) {
          isCancel = false;
          print("松开 发送");
          updateRecordAudioState(
            RecordAudioState(
                recording: true,
                recordingState: 1,
                noticeMessage: StrRes.releaseToSend,
              ),
          );
        } else {
          isCancel = true;
          updateRecordAudioState(
            RecordAudioState(
                recording: true,
                recordingState: -1,
                noticeMessage: StrRes.releaseToCancel),
          );
        }
        _updateAudioRecord();
      },
      onVerticalDragEnd: (DragEndDetails details) {
        setState(() {
          isRecording = false;
        });
        _cancelPressTimer();
        if (!isCancel) {
          _onRecordingEnd(); // 结束录制
        } else {
          _onRecordingCancel(); // 取消录制
        }
        //  _hideRecordingOverlay();
      },
      onVerticalDragCancel: () {
        if (!isRecording) {
          return; // 如果不在录制状态，则直接返回，避免重复取消录制
        }
        setState(() {
          isRecording = false;
        });
        _cancelPressTimer();
        _onRecordingCancel(); // 直接取消录制
        updateRecordAudioState(
          RecordAudioState(
              recording: false,
              recordingState: 1,
              noticeMessage: 'cancel'),
        );
        // _hideRecordingOverlay();
      },
      child: Container(
        height: 62.h,
        child: Center(
          child: Text(
            !isRecording ? '按住 说话' : '松开 结束',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _showRecordingOverlay() {
    // 显示滑块遮罩和半透明遮罩
    // 显示中间的状态框，状态框显示为绿色
    _showAudioRecord();
  }

  void _hideRecordingOverlay() {
    // 隐藏滑块遮罩和半透明遮罩
    // 隐藏中间的状态框
    _hideAudioRecord();
  }

  void _onRecordingEnd() {
    print("录制结束");
    _hideAudioRecord();
  }

  void _onRecordingCancel() {
    print("取消录制");
    _hideAudioRecord();
  }
}

class _QuoteView extends StatelessWidget {
  const _QuoteView({
    Key? key,
    this.onClearQuote,
    required this.content,
  }) : super(key: key);
  final Function()? onClearQuote;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.h, left: 56.w, right: 100.w),
      color: Styles.c_F0F2F6,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClearQuote,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: Styles.ts_8E9AB0_14sp,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ImageRes.delQuote.toImage
                ..width = 14.w
                ..height = 14.h,
            ],
          ),
        ),
      ),
    );
  }
}
