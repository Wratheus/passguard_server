import 'package:intl/intl.dart';

extension DateParsing on int {
  String toDateFormatted([String format = 'MM.dd.yyyy, HH:mm']) {
    return DateFormat(format)
        .format(DateTime.fromMillisecondsSinceEpoch(this))
        .toString();
  }
}