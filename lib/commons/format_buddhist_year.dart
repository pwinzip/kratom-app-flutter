import 'package:intl/intl.dart';

String formatBuddhistYear(DateFormat dateFormat, DateTime dt) {
  int normalYear = dt.year;
  int buddhistYear = normalYear + 543;
  String dateString = dateFormat
      .format(dt)
      .replaceAll(normalYear.toString(), buddhistYear.toString());

  return dateString;
}
