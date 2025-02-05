import 'package:intl/intl.dart';

extension DateTimeAgo on DateTime {
  /// "dd/MM/yyyy:HH:mm:ss"
  String formatDataTime() {
    return DateFormat("dd/MM/yyyy:HH:mm:ss").format(this);
  }

  /// Returns a string in the format "dd/mm/yyyy"
  String toDayMonthYear() {
    return '$day/$month/$year $hour:$minute:$second';
  }

  /// Returns a string representing the date and time in a readable format. ex. "MM/DD/YYYY"
  String readableDateWithDash() {
    return '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}';
  }

  /// Returns a string representing the time in a readable format. ex. "HH:MM:SS"
  String readableTime() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}