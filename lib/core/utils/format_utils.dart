import 'package:intl/intl.dart';

class FormatUtils {
  /// Formatar valor monetário
  static String formatCurrency(double? value) {
    if (value == null) return '€0,00';
    final formatter = NumberFormat.currency(
      locale: 'pt_PT',
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }
  
  /// Formatar data
  static String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  /// Formatar data e hora
  static String formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  /// Formatar apenas hora
  static String formatTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('HH:mm').format(date);
  }
  
  /// Parsear data do formato ISO 8601
  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  /// Formatar número com separadores de milhares
  static String formatNumber(int? value) {
    if (value == null) return '0';
    final formatter = NumberFormat('#,##0', 'pt_PT');
    return formatter.format(value);
  }
  
  /// Capitalizar primeira letra
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  /// Truncar texto
  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
