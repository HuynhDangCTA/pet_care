
import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  static DateFormat _dateTimeFormat = DateFormat('hh:mm dd-MM-yyyy');

  static String format(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }
}