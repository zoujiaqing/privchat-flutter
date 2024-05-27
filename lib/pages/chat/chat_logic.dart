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
import '../../core/controller/app_controller.dart';
import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../conversation/conversation_logic.dart';
import 'package:privchat_common/src/utils/event_bus_utils.dart';
import '../../widgets/chat_input_box/chat_input_box_logic.dart';

class ChatLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final appLogic = Get.find<AppController>();
  final conversationLogic = Get.find<ConversationLogic>();
  final cacheLogic = Get.find<CacheController>();
  final downloadLogic = Get.find<DownloadController>();

  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final scrollController = ScrollController();
  final refreshController = RefreshController();

  final forceCloseToolbox = PublishSubject<bool>();
  final forceCloseMenuSub = PublishSubject<bool>();
  final sendStatusSub = PublishSubject<MsgStreamEv<bool>>();
  final sendProgressSub = BehaviorSubject<MsgStreamEv<int>>();
  final downloadProgressSub = PublishSubject<MsgStreamEv<double>>();

  late Rx<ConversationInfo> conversationInfo;
  Message? searchMessage;
  final nickname = ''.obs;
  final faceUrl = ''.obs;
  Timer? typingTimer;
  final typing = false.obs;
  final intervalSendTypingMsg = IntervalDo();
  Message? quoteMsg;
  final messageList = <Message>[].obs;
  final quoteContent = "".obs;
  final atUserNameMappingMap = <String, String>{};
  final atUserInfoMappingMap = <String, UserInfo>{};
  final curMsgAtUser = <String>[];
  var _lastCursorIndex = -1;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  Timer? onlineStatusTimer;
  final memberUpdateInfoMap = <String, GroupMembersInfo>{};
  final groupMessageReadMembers = <String, List<String>>{};
  final groupMemberRoleLevel = 1.obs;
  GroupInfo? groupInfo;
  GroupMembersInfo? groupMembersInfo;

  final isInGroup = true.obs;
  final memberCount = 0.obs;
  final isInBlacklist = false.obs;

  final scrollingCacheMessageList = <Message>[];
  late StreamSubscription memberAddSub;
  late StreamSubscription memberDelSub;
  late StreamSubscription joinedGroupAddedSub;
  late StreamSubscription joinedGroupDeletedSub;
  late StreamSubscription memberInfoChangedSub;
  late StreamSubscription groupInfoUpdatedSub;
  late StreamSubscription friendInfoChangedSub;

  late StreamSubscription connectionSub;
  final syncStatus = IMSdkStatus.syncEnded.obs;

  int? lastMinSeq;

  bool _isReceivedMessageWhenSyncing = false;
  bool _isStartSyncing = false;
  bool _isFirstLoad = false;

  String? groupOwnerID;

  String? get userID => conversationInfo.value.userID;

  String? get groupID => conversationInfo.value.groupID;

  bool get isSingleChat => null != userID && userID!.trim().isNotEmpty;

  bool get isGroupChat => null != groupID && groupID!.trim().isNotEmpty;

  RTCBridge? rtcBridge = PackageBridge.rtcBridge;

  bool get rtcIsBusy => rtcBridge?.hasConnection == true;

  bool isCurrentChat(Message message) {
    var senderId = message.sendID;
    var receiverId = message.recvID;
    var groupId = message.groupID;
    // var sessionType = message.sessionType;
    var isCurSingleChat = message.isSingleChat && isSingleChat && (senderId == userID || senderId == OpenIM.iMManager.userID && receiverId == userID);
    var isCurGroupChat = message.isGroupChat && isGroupChat && groupID == groupId;
    return isCurSingleChat || isCurGroupChat;
  }

  void scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(0);
    });
  }

  @override
  void onReady() {
    _checkInBlacklist();
    _isJoinedGroup();
    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited = true;
    });
    super.onReady();
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    conversationInfo = Rx(arguments['conversationInfo']);
    searchMessage = arguments['searchMessage'];
    nickname.value = conversationInfo.value.showName ?? '';
    faceUrl.value = conversationInfo.value.faceURL ?? '';

    _setSdkSyncDataListener();

    imLogic.onRecvNewMessage = (Message message) {
      if (isCurrentChat(message)) {
        if (message.contentType == MessageType.typing) {
          if (message.typingElem?.msgTips == 'yes') {
            if (null == typingTimer) {
              typing.value = true;
              typingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
                typing.value = false;
                typingTimer?.cancel();
                typingTimer = null;
              });
            }
          } else {
            typing.value = false;
            typingTimer?.cancel();
            typingTimer = null;
          }
        } else {
          if (!messageList.contains(message) && !scrollingCacheMessageList.contains(message)) {
            _isReceivedMessageWhenSyncing = true;
            if (scrollController.offset != 0) {
              scrollingCacheMessageList.add(message);
            } else {
              messageList.add(message);
              scrollBottom();
            }
          }
        }
      }
    };

    imLogic.onRecvMessageRevoked = (RevokedInfo info) {
      var message = messageList.firstWhereOrNull((e) => e.clientMsgID == info.clientMsgID);
      message?.notificationElem = NotificationElem(detail: jsonEncode(info));
      message?.contentType = MessageType.revokeMessageNotification;

      if (null != message) {
        messageList.refresh();
      }
    };

    imLogic.onRecvC2CReadReceipt = (List<ReadReceiptInfo> list) {
      try {
        for (var readInfo in list) {
          if (readInfo.userID == userID) {
            for (var e in messageList) {
              if (readInfo.msgIDList?.contains(e.clientMsgID) == true) {
                e.isRead = true;
                e.hasReadTime = _timestamp;
              }
            }
          }
        }
        messageList.refresh();
      } catch (e) {}
    };

    imLogic.onRecvGroupReadReceipt = (List<ReadReceiptInfo> list) {
      try {} catch (e) {}
    };

    imLogic.onMsgSendProgress = (String msgId, int progress) {
      sendProgressSub.addSafely(
        MsgStreamEv<int>(id: msgId, value: progress),
      );
    };

    joinedGroupAddedSub = imLogic.joinedGroupAddedSubject.listen((event) {
      if (event.groupID == groupID) {
        isInGroup.value = true;
        _queryGroupInfo();
      }
    });

    joinedGroupDeletedSub = imLogic.joinedGroupDeletedSubject.listen((event) {
      if (event.groupID == groupID) {
        isInGroup.value = false;
        inputCtrl.clear();
      }
    });

    memberAddSub = imLogic.memberAddedSubject.listen((info) {
      var groupId = info.groupID;
      if (groupId == groupID) {
        _putMemberInfo([info]);
      }
    });

    memberDelSub = imLogic.memberDeletedSubject.listen((info) {
      if (info.groupID == groupID && info.userID == OpenIM.iMManager.userID) {
        isInGroup.value = false;
        inputCtrl.clear();
      }
    });

    memberInfoChangedSub = imLogic.memberInfoChangedSubject.listen((info) {
      if (info.groupID == groupID) {
        if (info.userID == OpenIM.iMManager.userID) {
          groupMemberRoleLevel.value = info.roleLevel ?? GroupRoleLevel.member;
        }
        _putMemberInfo([info]);
      }
    });

    groupInfoUpdatedSub = imLogic.groupInfoUpdatedSubject.listen((value) {
      if (groupID == value.groupID) {
        nickname.value = value.groupName ?? '';
        faceUrl.value = value.faceURL ?? '';
        memberCount.value = value.memberCount ?? 0;
      }
    });

    friendInfoChangedSub = imLogic.friendInfoChangedSubject.listen((value) {
      if (userID == value.userID) {
        nickname.value = value.getShowName();
        faceUrl.value = value.faceURL ?? '';
      }
    });

    inputCtrl.addListener(() {
      intervalSendTypingMsg.run(
        fuc: () => sendTypingMsg(focus: true),
        milliseconds: 2000,
      );
      clearCurAtMap();
    });

    focusNode.addListener(() {
      _lastCursorIndex = inputCtrl.selection.start;
      focusNodeChanged(focusNode.hasFocus);
    });

    super.onInit();


    scrollController.addListener(() {
      eventBus.fire(HideBottomEvent());
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    });
  }

  void chatSetup() => isSingleChat
      ? AppNavigator.startChatSetup(conversationInfo: conversationInfo.value)
      : AppNavigator.startGroupChatSetup(conversationInfo: conversationInfo.value);

  void clearCurAtMap() {
    curMsgAtUser.removeWhere((uid) => !inputCtrl.text.contains('@$uid '));
  }

  /// [isPinned] true: pin, false: unpin
  void setConversationTop(bool isPinned) {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.conversationManager.pinConversation(conversationID: conversationInfo.value.conversationID, isPinned: isPinned).then((value) => this.conversationInfo.update((val) {
            val?.isPinned = isPinned;
          })),
    );
  }

  /// [status] 0: normal; 1: not receiving messages; 2: receive online messages but not offline messages
  void setConversationDisturb(int status) {
    LoadingView.singleton.wrap(
      asyncFunction: () => OpenIM.iMManager.conversationManager.setConversationRecvMessageOpt(conversationID: conversationInfo.value.conversationID, status: status)
        .then((value) => this.conversationInfo.update((val) {
          val?.recvMsgOpt = status;
        })),
    );
  }

  void _putMemberInfo(List<GroupMembersInfo>? list) {
    list?.forEach((member) {
      _setAtMapping(
        userID: member.userID!,
        nickname: member.nickname!,
        faceURL: member.faceURL,
      );
      memberUpdateInfoMap[member.userID!] = member;
    });

    messageList.refresh();
    atUserNameMappingMap[OpenIM.iMManager.userID] = StrRes.you;
    atUserInfoMappingMap[OpenIM.iMManager.userID] = OpenIM.iMManager.userInfo;
  }

  var _mPlayerIsInited = false;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  playSound(String path) async {
    log("playSoundplaySoundplaySound:${path}");
    await _mPlayer!.startPlayer(
    fromURI: path,
    sampleRate: 44000,
    codec: Codec.opusWebM,
    numChannels: 1,
    );
  }

  sendAudio(String path,int duration) async {
    if (duration<=1){
      IMViews.showToast("消息太短啦");
      return;
    }
    print("sendAudiosendAudiosendAudio:${path} : ${duration} : ${File(path).existsSync()}");
    sendVoiceMsg(path: path, duration: duration);
  }

  void sendTextMsg() async {
    var content = IMUtils.safeTrim(inputCtrl.text);
    if (content.isEmpty) return;
    Message message;
    if (curMsgAtUser.isNotEmpty) {
      createAtInfoByID(id) => AtUserInfo(
            atUserID: id,
            groupNickname: atUserNameMappingMap[id],
          );

      message = await OpenIM.iMManager.messageManager.createTextAtMessage(
        text: content,
        atUserIDList: curMsgAtUser,
        atUserInfoList: curMsgAtUser.map(createAtInfoByID).toList(),
        quoteMessage: quoteMsg,
      );
    } else if (quoteMsg != null) {
      message = await OpenIM.iMManager.messageManager.createQuoteMessage(
        text: content,
        quoteMsg: quoteMsg!,
      );
    } else {
      message = await OpenIM.iMManager.messageManager.createTextMessage(
        text: content,
      );
    }
    _sendMessage(message);
  }


  // /storage/emulated/0/Android/data/cn.privchat.messenger/files/sound/flutter_sound_example.pcm
  // /data/user/0/cn.privchat.messenger/app_flutter/sound/flutter_sound_example.pcm
  // /data/user/0/cn.privchat.messenger/app_flutter//data/user/0/cn.privchat.messenger/app_flutter/flutter_sound_example.pcm
  void sendVoiceMsg({
    required String path,
    required int duration
    }) async {

    var dir =await getApplicationDocumentsDirectory();
    var descPath = "${dir.path}/flutter_sound_example.pcm";
    print("sendVoiceMsg:${path}");
    print("sendVoiceMsg:${descPath}");
    var file = await File(path).copy(descPath);
    var message = await OpenIM.iMManager.messageManager.createSoundMessage(
      soundPath: "flutter_sound_example.pcm",
      duration: duration
    );
    _sendMessage(message);
  }


  void sendPicture({required String path}) async {
    final file = await IMUtils.compressImageAndGetFile(File(path));

    var message = await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
      imagePath: file!.path,
    );
    _sendMessage(message);
  }

  Future<SearchResult> getMediaMessages({
    int searchTimePosition = 0,
    int pageIndex = 1,
    int count = 20,
  }) =>
      OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.value.conversationID,
        messageTypeList: [MessageType.picture, MessageType.video],
        searchTimePosition: searchTimePosition,
        pageIndex: pageIndex,
        count: count,
      );

  void sendVideo({
    required String videoPath,
    required String mimeType,
    required int duration,
    required String thumbnailPath,
  }) async {
    var d = duration > 1000.0 ? duration / 1000.0 : duration;
    var message = await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
      videoPath: videoPath,
      videoType: mimeType,
      duration: d.toInt(),
      snapshotPath: thumbnailPath,
    );
    _sendMessage(message);
  }

  void sendTypingMsg({bool focus = false}) async {
    if (isSingleChat) {
      OpenIM.iMManager.messageManager.typingStatusUpdate(
        userID: userID!,
        msgTip: focus ? 'yes' : 'no',
      );
    }
  }

  void _sendMessage(
    Message message, {
    String? userId,
    String? groupId,
    bool addToUI = true,
  }) {
    log('send : ${json.encode(message)}');
    userId = IMUtils.emptyStrToNull(userId);
    groupId = IMUtils.emptyStrToNull(groupId);
    if (null == userId && null == groupId || userId == userID && userId != null || groupId == groupID && groupId != null) {
      if (addToUI) {
        messageList.add(message);
        scrollBottom();
      }
    }
    Logger.print('uid:$userID userId:$userId gid:$groupID groupId:$groupId');
    _reset(message);

    bool useOuterValue = null != userId || null != groupId;
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          userID: useOuterValue ? userId : userID,
          groupID: useOuterValue ? groupId : groupID,
          offlinePushInfo: Config.offlinePushInfo,
        )
        .then((value) => _sendSucceeded(message, value))
        .catchError((error, _) => _senFailed(message, groupId, error, _))
        .whenComplete(() => _completed());
  }

  void _sendSucceeded(Message oldMsg, Message newMsg) {
    Logger.print('message send success----');

    oldMsg.update(newMsg);
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: oldMsg.clientMsgID!,
      value: true,
    ));
  }

  void _senFailed(Message message, String? groupId, error, stack) async {
    Logger.print('message send failed e :$error  $stack');
    message.status = MessageStatus.failed;
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: message.clientMsgID!,
      value: false,
    ));
    if (error is PlatformException) {
      int code = int.tryParse(error.code) ?? 0;
      if (isSingleChat) {
        int? customType;
        if (code == SDKErrorCode.hasBeenBlocked) {
          customType = CustomMessageType.blockedByFriend;
        } else if (code == SDKErrorCode.notFriend) {
          customType = CustomMessageType.deletedByFriend;
        }
        if (null != customType) {
          final hintMessage = (await OpenIM.iMManager.messageManager.createFailedHintMessage(type: customType))
            ..status = 2
            ..isRead = true;
          messageList.add(hintMessage);
          OpenIM.iMManager.messageManager.insertSingleMessageToLocalStorage(
            message: hintMessage,
            receiverID: userID,
            senderID: OpenIM.iMManager.userID,
          );
        }
      } else {
        if ((code == SDKErrorCode.userIsNotInGroup || code == SDKErrorCode.groupDisbanded) && null == groupId) {
          final status = groupInfo?.status;
          final hintMessage = (await OpenIM.iMManager.messageManager
              .createFailedHintMessage(type: status == 2 ? CustomMessageType.groupDisbanded : CustomMessageType.removedFromGroup))
            ..status = 2
            ..isRead = true;
          messageList.add(hintMessage);
          OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
            message: hintMessage,
            groupID: groupID,
            senderID: OpenIM.iMManager.userID,
          );
        }
      }
    }
  }

  void _reset(Message message) {
    if (message.contentType == MessageType.text || message.contentType == MessageType.atText || message.contentType == MessageType.quote) {
      inputCtrl.clear();
    }
  }

  void _completed() {
    messageList.refresh();
  }

  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
    );
    if (null != assets) {
      for (var asset in assets) {
        _handleAssets(asset);
      }
    }
  }

  void onTapCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      Get.context!,
      locale: Get.locale,
      pickerConfig: CameraPickerConfig(
          enableAudio: true,
          enableRecording: true,
          enableScaledPreview: false,
          resolutionPreset: ResolutionPreset.medium,
          maximumRecordingDuration: 60.seconds),
    );
    _handleAssets(entity);
  }

  void _handleAssets(AssetEntity? asset) async {
    if (null != asset) {
      Logger.print('--------assets type-----${asset.type}');
      var path = (await asset.file)!.path;
      Logger.print('--------assets path-----$path');
      switch (asset.type) {
        case AssetType.image:
          sendPicture(path: path);
          break;
        case AssetType.video:
          var thumbnailFile = await IMUtils.getVideoThumbnail(File(path));
          LoadingView.singleton.show();
          final file = await IMUtils.compressVideoAndGetFile(File(path));
          LoadingView.singleton.dismiss();

          sendVideo(
            videoPath: file!.path,
            mimeType: asset.mimeType ?? IMUtils.getMediaType(path) ?? '',
            duration: asset.duration,
            thumbnailPath: thumbnailFile.path,
          );

          break;
        default:
          break;
      }
    }
  }

  void parseClickEvent(Message msg) async {
    if (msg.contentType == MessageType.text) {
      var data = msg.customElem?.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      if (CustomMessageType.call == customType && !isInBlacklist.value) {
      } else if (CustomMessageType.meeting == customType) {}
      return;
    }
    if (msg.contentType == MessageType.voice && msg.soundElem!.sourceUrl!=null) {
      var dir =await getApplicationDocumentsDirectory();
      var descPath = "${dir.path}/cache/sound/${msg.clientMsgID}.pcm";
      var file = File(descPath);
      if (!file.existsSync()){
        file.createSync(recursive: true);
        await Dio().download(msg.soundElem!.sourceUrl!, descPath);
      }
      playSound(descPath);
      return;
    }
    IMUtils.parseClickEvent(
      msg,
      messageList: messageList,
      onViewUserInfo: viewUserInfo,
    );
  }

  void onLongPressLeftAvatar(Message message) {}

  void onClickMenuTapItem(int index, StarMenuController controller, Message message) {
    print(message.toJson());
    print("122221" + " " + index.toString());
    controller.closeMenu!();
    switch (index) {
      //复制
      case 0:
        copyText(message.textElem!.content!);
        break;
      case 1: //回复
        break;
      case 2: //撤销
        break;
      case 3: //删除
        deleteMessage(message);
        break;
      case 4: //转发
        break;
    }
  }
  void copyText(String text) {

    Clipboard.setData(ClipboardData(text: text));
    IMViews.showToast(StrRes.copySuccessfully);
  }

  void deleteMessage(Message message) async {
    await OpenIM.iMManager.messageManager.deleteMessageFromLocalAndSvr(conversationID: conversationInfo.value.conversationID!, clientMsgID: message.clientMsgID!);


  }

  void onTapLeftAvatar(Message message) {
    if (isGroupChat) {
      Get.lazyPut(() => GroupSetupLogic());
    }
    viewUserInfo(UserInfo()
      ..userID = message.sendID
      ..nickname = message.senderNickname
      ..faceURL = message.senderFaceUrl);
  }

  void onTapRightAvatar() {
    viewUserInfo(OpenIM.iMManager.userInfo);
  }

  void viewUserInfo(UserInfo userInfo) {
    AppNavigator.startUserProfilePane(
      userID: userInfo.userID!,
      account: userInfo.account,
      nickname: userInfo.nickname,
      faceURL: userInfo.faceURL,
      groupID: groupID,
      offAllWhenDelFriend: isSingleChat,
      conversationInfo: conversationInfo.value
    );
  }

  String createDraftText() {
    return json.encode({});
  }

  exit() async {
    Get.back(result: createDraftText());
    return true;
  }

  void focusNodeChanged(bool hasFocus) {
    sendTypingMsg(focus: hasFocus);
    if (hasFocus) {
      Logger.print('focus:$hasFocus');
      scrollBottom();
    }
  }

  void copy(Message message) {
    IMUtils.copy(text: message.textElem!.content!);
  }

  Message indexOfMessage(int index, {bool calculate = true}) => IMUtils.calChatTimeInterval(
        messageList,
        calculate: calculate,
      ).reversed.elementAt(index);

  ValueKey itemKey(Message message) => ValueKey(message.clientMsgID!);

  @override
  void onClose() {
    inputCtrl.dispose();
    focusNode.dispose();

    forceCloseToolbox.close();
    sendStatusSub.close();
    sendProgressSub.close();
    downloadProgressSub.close();
    memberAddSub.cancel();
    memberDelSub.cancel();
    memberInfoChangedSub.cancel();
    groupInfoUpdatedSub.cancel();
    friendInfoChangedSub.cancel();

    forceCloseMenuSub.close();
    joinedGroupAddedSub.cancel();
    joinedGroupDeletedSub.cancel();
    connectionSub.cancel();

    super.onClose();
  }

  String? getShowTime(Message message) {
    if (message.exMap['showTime'] == true) {
      return IMUtils.getChatTimeline(message.sendTime!);
    }
    return null;
  }

  void clearAllMessage() {
    messageList.clear();
  }

  String? get subTile => typing.value ? StrRes.typing : null;

  String get title => isSingleChat ? nickname.value : (memberCount.value > 0 ? '${nickname.value}(${memberCount.value})' : nickname.value);

  void failedResend(Message message) {
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: message.clientMsgID!,
      value: true,
    ));
    _sendMessage(message..status = MessageStatus.sending, addToUI: false);
  }

  static int get _timestamp => DateTime.now().millisecondsSinceEpoch;

  void _queryMyGroupMemberInfo() async {
    if (isGroupChat) {
      var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: [OpenIM.iMManager.userID],
      );
      groupMembersInfo = list.firstOrNull;
      groupMemberRoleLevel.value = groupMembersInfo?.roleLevel ?? GroupRoleLevel.member;
      if (null != groupMembersInfo) {
        memberUpdateInfoMap[OpenIM.iMManager.userID] = groupMembersInfo!;
      }
    }
  }

  void _isJoinedGroup() async {
    if (isGroupChat) {
      isInGroup.value = await OpenIM.iMManager.groupManager.isJoinedGroup(
        groupID: groupID!,
      );
      if (isInGroup.value) _queryGroupInfo();
    }
  }

  void _queryGroupInfo() async {
    if (isGroupChat) {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID!],
      );
      groupInfo = list.firstOrNull;
      groupOwnerID = groupInfo?.ownerUserID;
      memberCount.value = groupInfo?.memberCount ?? 0;
      _queryMyGroupMemberInfo();
    }
  }

  bool get havePermissionMute => isGroupChat && (groupInfo?.ownerUserID == OpenIM.iMManager.userID);

  bool isNotificationType(Message message) => message.contentType! >= 1000;

  Map<String, String> getAtMapping(Message message) {
    return {};
  }

  void lockMessageLocation(Message message) {}

  void _checkInBlacklist() async {
    if (userID != null) {
      var list = await OpenIM.iMManager.friendshipManager.getBlacklist();
      var user = list.firstWhereOrNull((e) => e.userID == userID);
      isInBlacklist.value = user != null;
    }
  }

  void _setAtMapping({
    required String userID,
    required String nickname,
    String? faceURL,
  }) {
    atUserNameMappingMap[userID] = nickname;
    atUserInfoMappingMap[userID] = UserInfo(
      userID: userID,
      nickname: nickname,
      faceURL: faceURL,
    );
  }

  bool isExceed24H(Message message) {
    int milliseconds = message.sendTime!;
    return !DateUtil.isToday(milliseconds);
  }

  String? getNewestNickname(Message message) {
    if (isSingleChat) null;
    return memberUpdateInfoMap[message.sendID]?.nickname;
  }

  String? getNewestFaceURL(Message message) {
    if (isSingleChat) return faceUrl.value;
    return memberUpdateInfoMap[message.sendID]?.faceURL;
  }

  bool get isInvalidGroup => !isInGroup.value && isGroupChat;

  bool isNoticeMessage(Message message) => message.contentType! > 1000;

  void joinGroupCalling() async {}

  void call() {
    if (rtcIsBusy) {
      IMViews.showToast(StrRes.callingBusy);
      return;
    }

    IMViews.openIMCallSheet(nickname.value, (index) {
      imLogic.call(
        callObj: CallObj.single,
        callType: index == 0 ? CallType.audio : CallType.video,
        inviteeUserIDList: [if (isSingleChat) userID!],
      );
    });
  }

  void onScrollToTop() {
    if (scrollingCacheMessageList.isNotEmpty) {
      messageList.addAll(scrollingCacheMessageList);
      scrollingCacheMessageList.clear();
    }
  }

  String get markText {
    String? phoneNumber = imLogic.userInfo.value.phoneNumber;
    if (phoneNumber != null) {
      int start = phoneNumber.length > 4 ? phoneNumber.length - 4 : 0;
      final sub = phoneNumber.substring(start);
      return "${OpenIM.iMManager.userInfo.nickname!}$sub";
    }
    return OpenIM.iMManager.userInfo.nickname ?? '';
  }

  bool isFailedHintMessage(Message message) {
    if (message.contentType == MessageType.custom) {
      var data = message.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      return customType == CustomMessageType.deletedByFriend || customType == CustomMessageType.blockedByFriend;
    }
    return false;
  }

  void sendFriendVerification() => AppNavigator.startSendVerificationApplication(userID: userID);

  void _setSdkSyncDataListener() {
    connectionSub = imLogic.imSdkStatusSubject.listen((value) {
      syncStatus.value = value;

      if (value == IMSdkStatus.syncStart) {
        _isStartSyncing = true;
      } else if (value == IMSdkStatus.syncEnded) {
        if (_isStartSyncing) {
          _isReceivedMessageWhenSyncing = false;
          _isStartSyncing = false;
          _isFirstLoad = true;
          onScrollToBottomLoad();
        }
      } else if (value == IMSdkStatus.syncFailed) {
        _isReceivedMessageWhenSyncing = false;
        _isStartSyncing = false;
      }
    });
  }

  bool get isSyncFailed => syncStatus.value == IMSdkStatus.syncFailed;

  String? get syncStatusStr {
    switch (syncStatus.value) {
      case IMSdkStatus.syncStart:
      case IMSdkStatus.synchronizing:
        return StrRes.synchronizing;
      case IMSdkStatus.syncFailed:
        return StrRes.syncFailed;
      default:
        return null;
    }
  }

  bool showBubbleBg(Message message) {
    return !isNotificationType(message) && !isFailedHintMessage(message);
  }

  Future<AdvancedMessage> _requestHistoryMessage() => OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
        conversationID: conversationInfo.value.conversationID,
        count: 20,
        startMsg: _isFirstLoad ? null : messageList.firstOrNull,
        lastMinSeq: _isFirstLoad ? null : lastMinSeq,
      );

  Future<bool> onScrollToBottomLoad() async {
    late List<Message> list;
    final result = await _requestHistoryMessage();
    if (result.messageList == null || result.messageList!.isEmpty) return false;
    list = result.messageList!;
    lastMinSeq = result.lastMinSeq;
    if (_isFirstLoad) {
      _isFirstLoad = false;
      messageList.assignAll(list);
      scrollBottom();
    } else {
      removeCallingCustomMessage(list);

      if (list.isNotEmpty && list.length < 20) {
        final result = await _requestHistoryMessage();
        if (result.messageList?.isNotEmpty == true) {
          list = result.messageList!;
          lastMinSeq = result.lastMinSeq;
        }
        removeCallingCustomMessage(list);
      }
      messageList.insertAll(0, list);
    }
    return list.length >= 20;
  }

  void removeCallingCustomMessage(List<Message> list) {
    list.removeWhere((element) {
      if (element.isCustomType) {
        if (element.customElem?.data != null) {
          var map = json.decode(element.customElem!.data!);
          var customType = map['customType'];

          final result = customType == CustomMessageType.callingInvite ||
              customType == CustomMessageType.callingAccept ||
              customType == CustomMessageType.callingReject ||
              customType == CustomMessageType.callingHungup ||
              customType == CustomMessageType.callingCancel;

          return result;
        }
      }

      return false;
    });
  }
}
