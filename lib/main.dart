import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privchat_common/privchat_common.dart';

import 'app.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      systemNavigationBarColor: Colors.green,
      systemNavigationBarDividerColor: Colors.green,

    ));
  }
  Config.init(() => runApp(const ChatApp()));
  WidgetsFlutterBinding.ensureInitialized();

}
