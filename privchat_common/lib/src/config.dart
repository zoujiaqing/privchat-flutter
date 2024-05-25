import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:privchat_common/privchat_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:getuiflut/getuiflut.dart';

class Config {

  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      cachePath = '$path/';
      await DataSp.init();
      await Hive.initFlutter(path);
      HttpUtil.init();
    } catch (_) {}
    runApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));

  }

  static late String cachePath;
  static const uiW = 375.0;
  static const uiH = 812.0;

  static const String deptName = "PrivChat";
  static const String deptID = '0';

  static const double textScaleFactor = 1.0;

  static const secret = 'privchat';

  static const mapKey = '';

  static OfflinePushInfo offlinePushInfo = OfflinePushInfo(
    title: StrRes.offlineMessage,
    desc: "",
    iOSBadgeCount: true,
    iOSPushSound: '+1',
  );

  static const friendScheme = "cn.privchat.messenger/addFriend/";
  static const groupScheme = "cn.privchat.messenger/joinGroup/";
  
  static const appAuthUrl = "https://web.privchat.cn/logic";
  static const imApiUrl = "https://web.privchat.cn/api";
  static const imWsUrl = "wss://web.privchat.cn/gateway";
}
