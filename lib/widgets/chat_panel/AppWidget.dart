import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class AppWidget{
  static Widget inkWellEffectNone({ ValueKey? key, required Null Function() onTap, required Widget child}) {
    return InkWell(key: key, onTap: onTap, child: child,);
  }

  static iconBack(Null Function() param0) {
    return Icon(Icons.arrow_back_ios, color: Colors.black, size: 20);
  }

}