import 'package:intl/intl.dart';

class DateTimeConverter {
  static String convertDateToString(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String convertTimeToString(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static DateTime convertStringToDate(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  static DateTime convertStringToTime(String date) {
    return DateFormat('HH:mm').parse(date);
  }
}
