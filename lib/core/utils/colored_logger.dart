// ignore_for_file: constant_identifier_names
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'dart:developer' as developer show log;

dastrasLog(dynamic text) {
  if (!kReleaseMode) {
    developer.log(text);
  }
}

enum ColoredLogger {
  Black("30", "⚫️"),
  Red("31", "🔴"),
  Green("32", "🟢"),
  Yellow("33", "🟡"),
  Blue("34", "🔵"),
  Magenta("35", "🟣"),
  White("37", "⚪️");

  final String code;
  final String emoji;
  const ColoredLogger(this.code, this.emoji);

  static const maxWidth = 90;

  void log(dynamic text) {
    if (!kReleaseMode) developer.log('\x1B[${code}m$emoji$text$emoji\x1B[0m');
  }

  String get emojiStart => '$emoji \x1B[${code}m';
  String get emojiEnd => ' $emoji \x1B[0m';
  String get normalStart => '\x1B[${code}m';
  String get normalEnd => '\x1B[0m';
}
