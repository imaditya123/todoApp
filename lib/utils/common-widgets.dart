import 'package:intl/intl.dart';
import 'package:todo/index.dart';

class CommonWidgets {
  static showToast(BuildContext context, String message, {int? duration}) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static push(BuildContext context, Widget route) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => route, fullscreenDialog: true),
    );
  }

  static bool isInt(String str) {
    if (str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  static bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static bool isTimeStamp(String str) {
    if (str == null) {
      return false;
    }
    try {
      if (isInt(str) && str.length == 13) {
        DateTime.fromMillisecondsSinceEpoch(int.parse(str));
        return true;
      }
    } catch (e) {}
    return false;
  }

  static String convertToUrl(Map<String, dynamic> parsedJson) {
    final keyList = parsedJson.keys;
    String data = "";
    keyList.forEach((ele) {
      if (parsedJson[ele] != null)
        data = "$data" + "&$ele" + "=" + "${parsedJson[ele]}";
    });
    data = "?" + data.substring(1);

    data = Uri.encodeFull(data);

    return data;
  }

  static String convertToDate(String date) {
    var s = "";
    print("date");
    print(date);
    try {
      final p = DateTime.parse(date);
      s = DateFormat('MMM  dd, yyyy').format(p);
    } catch (e) {}

    return s;
  }

 

  static String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  static String convertToFormatedDate(String date) {
    var s = "";
    try {
      final p = DateTime.parse(date);
      if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
          DateFormat('yyyy-MM-dd').format(p)) {
        s = DateFormat('hh:mmaaa').format(p) + " Today";
      } else if (DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 1))) ==
          DateFormat('yyyy-MM-dd').format(p)) {
        s = DateFormat('hh:mmaaa').format(p) + " Yday";
      } else {
        s = DateFormat('hh:mmaaa MMM  dd, yyyy').format(p);
      }
    } catch (e) {}

    return s;
  }

  static DateTime convertTimeOfDay(TimeOfDay t, {DateTime? p}) {
    var now = new DateTime.now();
    if (p != null) {
      now = p;
    }
    return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }
    static String convertToDay(int date) {
    var s = "";
    try {
      final p = DateTime.fromMillisecondsSinceEpoch(date);
      s = DateFormat('HH:mm  MMM  dd, yyyy').format(p);
    } catch (e) {}

    return s;
  }
   static String convertToDays(int date) {
    var s = "";
    try {
      final p = DateTime.fromMillisecondsSinceEpoch(date);
      s = DateFormat('MMM  dd, yyyy').format(p);
    } catch (e) {}

    return s;
  }
}
