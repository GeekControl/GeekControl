import 'package:intl/intl.dart';

class DateTimeUtil extends DateFormat {
  DateTimeUtil() : super('yyyy-MM-dd');

  int calculateDaysDifference(DateTime startDate, DateTime endDate) {
    Duration difference = endDate.difference(startDate);
    return difference.inDays;
  }

  // Exemplo *1715608800*
  DateTime unixDate(int data) {
    return DateTime.fromMillisecondsSinceEpoch(data * 1000);
  }

  String formatUnixDateTime(int date, String? format) {
    final specialDateTime = unixDate(date);

    String formattedDate = DateFormat(format ?? 'dd-MM-yyyy')
        .format(DateTime.parse(specialDateTime.toString()));
    formattedDate = formattedDate.replaceAll('-', '/');

    final String formattedHours =
        DateFormat('HH:mm').format(DateTime.parse(specialDateTime.toString()));

    return formattedDate = '$formattedDate ás ${formattedHours}hs';
  }
}
