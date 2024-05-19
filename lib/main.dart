import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privchat_common/privchat_common.dart';

import 'app.dart';

void main() {
  Config.init(() => runApp(const ChatApp()));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}
