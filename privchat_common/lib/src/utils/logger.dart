import 'package:flutter/foundation.dart';

class Logger {
  static void print(dynamic text, {bool isError = false}) {
    debugPrint('** $text, isError [$isError]');
  }
}
