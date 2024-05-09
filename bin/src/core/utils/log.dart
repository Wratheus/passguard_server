import 'dart:developer' as devtools;

import '../constants/enums.dart';
import 'date_formatter.dart';



extension Log on Object {
  static const bool _showLog = true;
  static const bool _showTime = true;
  static const bool _showEmoji = true;
  static const LogLevel _logLevel = LogLevel.debug;

  void log({required String name, LogLevel level = LogLevel.info}) {
    if (_showLog && _shouldLog(level)) {
      final String emoji = _showEmoji ? _getEmoji(level) : '';
      final String time = _showTime
          ? DateTime.now().millisecondsSinceEpoch
          .toDateFormatted('[dd/MM/yyyy] [HH:mm:ss] ')
          : '';
      final String logMessage =
          '$emoji$time[${level.name.toUpperCase()}] [$name] - ${toString()}';
      devtools.log(logMessage);
    }
  }

  String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🚧';
      case LogLevel.info:
        return '💬';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '🧨';
      case LogLevel.success:
        return '🟢';
      case LogLevel.interaction:
        return '👷🏻‍';
      default:
        return '';
    }
  }

  bool _shouldLog(LogLevel level) {
    return level.index >= _logLevel.index;
  }
}
