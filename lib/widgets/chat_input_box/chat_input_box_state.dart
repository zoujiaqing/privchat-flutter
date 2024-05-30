import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:privchat_common/privchat_common.dart';
import 'chat_audio_mask.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privchat/pages/chat/group_setup/group_setup_logic.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:privchat_live/privchat_live.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/subjects.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:star_menu/star_menu.dart';

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
  bool isReply = false;
  String replyMsg = "";
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

  void replyAction(String msg) {
    replyMsg = msg;
  }

  ChatInputBoxState() {

  }
}
