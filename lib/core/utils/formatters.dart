import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _priceFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  /// Formats a raw numeric string into e.g. "$1.78 trillion", "$4.13 billion",
  /// "$285.81 million"
  static String marketCap(String? rawValue) {
    final value = rawValue != null ? double.tryParse(rawValue) : null;
    if (value == null) return '--';

    if (value >= 1e12) {
      return '\$${(value / 1e12).toStringAsFixed(2)} trillion';
    } else if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)} billion';
    } else if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)} million';
    }
    return _priceFormat.format(value);
  }

  /// Formats a raw price string into "$123,405.98".
  static String price(String? rawValue) {
    final value = rawValue != null ? double.tryParse(rawValue) : null;
    if (value == null) return '--';
    return _priceFormat.format(value);
  }

  /// Converts from .svg to .png
  static String toRasterIconUrl(String svgUrl, {int size = 64}) {
    return svgUrl.replaceFirst('.svg', '.png?size=${size}x$size');
  }
}