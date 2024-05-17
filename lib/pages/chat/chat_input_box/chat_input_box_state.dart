import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:privchat_common/privchat_common.dart';
import '../../../widgets/chat_panel/provider_chat_content.dart';

typedef SendAudioCallBack = Function(String path, int duration);
typedef clickEmojiCallBack = Function();
class ChatInputBoxState {

  AtTextCallback? atCallback;
  SendAudioCallBack? sendAudio;
  Map<String, String> allAtMap = {};
  TextStyle? style;
  TextStyle? atStyle;
  List<TextInputFormatter>? inputFormatters;
  bool enabled = true;
  bool isMultiModel = false;
  bool isNotInGroup = false;
  String? hintText;
  Widget? emojiBox;
  ValueChanged<String>? onSend;
  Widget? toolbox;
  BuildContext? context;

  bool isCancel = false;
  bool isRecording = false;
  // 这个值可以根据 conversationId 记录下来状态
  bool voiceMode = false;
  bool toolsVisible = false;
  bool emojiVisible = false;
  bool sendButtonVisible = false;

  // 录音设置
  //todo: 初始化录音对象
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();

  // 录音状态
  RecordAudioState recordState = RecordAudioState(
    recording: false,
    recordingState: -1,
    noticeMessage: 'init',
  );

  TextEditingController? controller;
  FocusNode focusNode = FocusNode();

  void setController(TextEditingController newController){
    if(controller == null){
      controller = newController;
    }
  }

  ChatInputBoxState() {

  }
}
