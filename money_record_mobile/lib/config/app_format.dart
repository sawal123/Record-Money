import 'package:intl/intl.dart';

class AppFormat {
  static String date(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('dd MMMM YYYY', 'id_ID').format(dateTime);
  }
}
