import 'package:intl/intl.dart';

class DateHelper {
  static String normalDateToString(DateTime dateTime) {
    return DateFormat.yMd().format(dateTime);
  }

  static DateTime normalStringToDate(String date) {
    return DateFormat.yMd('en-Us').parse(date);
  }
}
