import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);

  static String monthYear(DateTime date) =>
      DateFormat('MMMM yyyy').format(date);

  static String dayMonth(DateTime date) =>
      DateFormat('dd MMM').format(date);
}