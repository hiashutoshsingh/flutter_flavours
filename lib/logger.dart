import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as Log;

class LoggerInst {
  static final LoggerInst _loggerInstance = LoggerInst._makeInstance();

  factory LoggerInst() {
    return _loggerInstance;
  }

  LoggerInst._makeInstance();

  static final logger = Log.Logger(
    printer: Log.PrettyPrinter(
      printEmojis: true,
      printTime: false,
      methodCount: 0,
    ),
  );

  static void print(String value) {
    if (!kReleaseMode) {
      logger.i(value);
    }
  }
}
