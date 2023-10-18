
import 'package:intl/intl.dart';

class NumberUtil {
  static final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  static final formatterNotd = NumberFormat.currency(locale: 'vi_VN');

  static String formatCurrency(value) {
    return formatter.format(value);
  }

  static num parseCurrency(String value) {
    return formatter.parse(value);
  }

  static String formatCurrencyNotD(value) {
    return formatterNotd.format(value);
  }


}