 import 'package:cloud_firestore/cloud_firestore.dart';
class Util {

static String toMonth(int m) {
    if (m == 1) return "Jan";
    if (m == 2) return "Feb";
    if (m == 3) return "Mar";
    if (m == 4) return "Apr";
    if (m == 5) return "May";
    if (m == 6) return "Jun";
    if (m == 7) return "Jul";
    if (m == 8) return "Aug";
    if (m == 9) return "Sep";
    if (m == 10) return "Oct";
    if (m == 11) return "Nov";
    if (m == 12) return "Dec";
    return "Month";
  }

  static String DDMMM(Timestamp timestamp) {
    return timestamp.toDate().day.toString() +
        " " +
        toMonth(timestamp.toDate().month);
  }

  static String padIt(String x, int totalchars) {
    var l = x.length;
    String ret = x;
    while (l < totalchars) {
      ret = ret + " ";
      l++;
    }
    return ret;
  }
}