import 'package:flutter/cupertino.dart';
import 'package:privchat/utils/int_ext.dart';

///用于 软键盘区/发送附件  域显示控制
class ProviderChatContent extends ChangeNotifier {
  bool _contentShow = false;
  double _keyboardHeight = 200;

  RecordAudioState _recordAudioState = RecordAudioState(
    recording: false,
    recordingState: -1,
    noticeMessage: '',
  );

  /// 是否显示 附件区域
  bool get contentShow => _contentShow;

  /// 键盘高度
  double get keyboardHeight => _keyboardHeight - 20.cale;

  RecordAudioState get recordAudioState => _recordAudioState;

  ///更新区域 展示
  void updateContentShow(bool isShow) {
    _contentShow = isShow;
    notifyListeners();
  }

  void updateKeyboardHeight(double height) {
    _keyboardHeight = height;
    notifyListeners();
  }

  void updateRecordAudioState(RecordAudioState state) {
    _recordAudioState = state;
    notifyListeners();
  }
}

class RecordAudioState {
  final bool recording;
  int recordingState;
  final String noticeMessage;
  RecordAudioState(
      {required this.recording,
        required this.recordingState,
        required this.noticeMessage});
}