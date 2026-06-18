import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'Rs ${formatter.format(amount)}';
  }
}