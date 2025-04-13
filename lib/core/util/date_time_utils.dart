import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  static List<DateTime> getLastNMonths(int n) {
    final now = DateTime.now();
    final List<DateTime> months = [];

    for (int i = 0; i < n; i++) {
      months.add(DateTime(now.year, now.month - i, 1));
    }

    return months;
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
