import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../widgets/chat_panel/chat_audio_mask.dart';
import 'chat_input_box_state.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privchat_common/src/utils/event_bus_utils.dart';
import 'package:privchat/widgets/chat_panel/provider_chat_content.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:privchat_common/privchat_common.dart';

class HideBottomEvent {}

class ChatInputBoxLogic extends GetxController {
  final ChatInputBoxState state = ChatInputBoxState();
  Timer? _pressTimer;
  Timer? _cancelAndRestartTimer;
  late OverlayEntry? _overlayEntry = null;
  late OverlayState? _overlayState = null;
  int duration = 0;
  bool _mRecorderIsInited = false; // 录音机是否初始化
  StreamSubscription? _mRecordingDataSubscription;

  @override
  void onInit() {
    super.onInit();
    initRecord();
    print("LTTTTTT:INIT");
    _overlayState = Overlay.of(Get.context!);
    eventBus.on<HideBottomEvent>().listen((event) {
      unfocus(Get.context!);
      state.toolsVisible = false;
      state.emojiVisible = false;
    });
    update();
  }

  @override
  void onReady() {
    super.onReady();
    print("LTTTTTT:ready");
    state.focusNode.addListener(() {
      if (state.focusNode.hasFocus) {
        state.toolsVisible = false;
        state.emojiVisible = false;
      }
    });
    state.controller!.addListener(() {
      state.sendButtonVisible = state.controller!.text.isNotEmpty;
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mRecordingDataSubscription!.cancel();
  }

  // 开始计时
  void _startPressTimer() {
    _pressTimer = Timer(Duration(milliseconds: 100), () {
      _showRecordingOverlay();
    });
  }

  void _cancelPressTimer() {
    _pressTimer?.cancel();
  }

  ///---------------------------录音准备
  initRecord() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await state.mRecorder!.openRecorder();
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

  String? _mPath;

  Future<IOSink> createFile() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.pcm';
    var outputFile = File(_mPath!);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  ///---------------------------录音开始
  void _showRecordingOverlay() {
    // 显示滑块遮罩和半透明遮罩
    // 显示中间的状态框，状态框显示为绿色
    _showAudioRecord();
  }

  void _startRecordingTimer() {
    Timer(Duration(seconds: 10), () {
      if (state.recordState.recording) {
        _onRecordingEnd();
      }
    });
  }

  void _showAudioRecord() {
    _startRecordingTimer();
    // _hideAudioRecord();
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return ChatAudioMask(recordAudioState: state.recordState);
    });
    _overlayState!.insert(_overlayEntry!);
    record();
  }

  Future<void> record() async {
    assert(_mRecorderIsInited);
    var sink = await createFile();

    var recordingDataController = StreamController<Food>();

    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        sink.add(buffer.data!);
      }
    });

    await state.mRecorder!.startRecorder(
        toStream: recordingDataController.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44000,
        enableVoiceProcessing: false);
    _cancelAndRestartTimer =
        Timer.periodic(const Duration(milliseconds: 800), (timer) {
      duration += 1;
    });
  }

  ///---------------------------取消录音
  // 录制结束
  void _onRecordingEnd() {
    print("录制结束");
    _hideAudioRecord();
  }

  // 取消录制
  void _onRecordingCancel() {
    print("取消录制");
    _hideAudioRecord();
  }

  Future<void> stopRecorder() async {
    _cancelAndRestartTimer?.cancel();
    await state.mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
    // _mplaybackReady = true;
  }

  Future<void> _hideAudioRecord() async {
    print("_hideAudioRecord 1  ${state.recordState.noticeMessage}");
    if (_overlayEntry != null) {
      print("_hideAudioRecord 2");
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (state.recordState.recording) {
        await stopRecorder();
        print("_hideAudioRecord 3  duration:${duration}");
        if (state.recordState.recordingState == 1 &&
            state.recordState.noticeMessage != "松开 取消" &&
            duration > 1) {
          print("_hideAudioRecord 4  ${state.recordState.recordingState}");
          state.sendAudio?.call(_mPath!, duration);
          updateRecordAudioState(RecordAudioState(
              recording: false, recordingState: -1, noticeMessage: ''));
          print("用户录音成功");
        } else {
          print("用户取消录音");
        }
        duration = 0;
      }
    }
  }

  // 更新录音状态
  void updateRecordAudioState(RecordAudioState newState) {
    state.recordState = newState;
    print("updateRecordAudioState_${state.recordState.recordingState}");
    update();
  }

  void _updateAudioRecord() {
    print("-------更新了----------");
    final overlayEntry = this._overlayEntry;
    if (overlayEntry != null) {
      overlayEntry.markNeedsBuild();
    }
  }

  void switchToVoice() {
    state.voiceMode = !state.voiceMode;
    state.toolsVisible = false;
    state.emojiVisible = false;
    // focus 了为啥不弹出键盘？
    state.voiceMode ? unfocus(state.context!) : focus(state.context!);
    update();
  }

  void changeButton() {
    print("changeButton");
    state.emojiVisible = !state.emojiVisible;
    state.toolsVisible = false;
    state.voiceMode = false;
    state.emojiVisible ? unfocus(Get.context!) : focus(Get.context!);
    update();
  }

  focus(BuildContext context) =>
      FocusScope.of(context).requestFocus(state.focusNode);

  unfocus(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  voiceButtonDragStart(DragStartDetails details) {
    if (state.isRecording) {
      return; // 如果正在录制，则直接返回，避免重复启动 Timer
    }
    state.isRecording = true;
    updateRecordAudioState(
      RecordAudioState(
          recording: true, recordingState: 1, noticeMessage: StrRes.releaseToSend),
    );
    _startPressTimer();
  }

  voiceButtonDragUpdate(DragUpdateDetails details) {
    if (details.localPosition.dy > -28) {
      state.isCancel = false;
      print("松开 发送");
      updateRecordAudioState(
        RecordAudioState(
            recording: true, recordingState: 1, noticeMessage: StrRes.releaseToSend),
      );
    } else {
      state.isCancel = true;
      updateRecordAudioState(
        RecordAudioState(
            recording: true, recordingState: -1, noticeMessage: StrRes.releaseToCancel),
      );
    }
    _updateAudioRecord();
  }

  voiceButtonDragEnd(DragEndDetails details) {
    state.isRecording = false;
    _cancelPressTimer();
    if (!state.isCancel) {
      _onRecordingEnd(); // 结束录制
    } else {
      _onRecordingCancel(); // 取消录制
    }
    //  _hideRecordingOverlay();
    update();
  }

  voiceButtonDragCancel() {
    if (!state.isRecording) {
      return; // 如果不在录制状态，则直接返回，避免重复取消录制
    }
    state.isRecording = false;
    _cancelPressTimer();
    _onRecordingCancel(); // 直接取消录制
    updateRecordAudioState(
      RecordAudioState(
          recording: false, recordingState: 1, noticeMessage: 'cancel'),
    );
    // _hideRecordingOverlay();
    update();
  }

  void send() {
    if (!state.enabled) return;
    if (!state.emojiVisible) focus(Get.context!);
    if (null != state.onSend && null != state.controller) {
      state.onSend!(state.controller!.text.toString().trim());
    }
    update();
  }

  void toggleToolbox() {
    print("toggleToolbox");
    if (!state.enabled) return;
    state.toolsVisible = !state.toolsVisible;
    state.emojiVisible = false;
    state.voiceMode = false;
    // _leftKeyboardButton = true;
    if (state.toolsVisible) {
      unfocus(Get.context!);
    } else {
      focus(Get.context!);
    }
    update();
  }
}
