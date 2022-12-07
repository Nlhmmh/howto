import 'package:intl/intl.dart';

class Utils {
  static String timeAgo(
    DateTime date, {
    bool numericDates = true,
  }) {
    final timeDiff = DateTime.now().difference(
      DateFormat("yyyy-MM-dd HH:mm:ss").parse(
        date.toString(),
      ),
    );
    if (timeDiff.inDays > 8) {
      return '${timeDiff.inDays} days ago';
    } else if ((timeDiff.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (timeDiff.inDays >= 2) {
      return '${timeDiff.inDays} days ago';
    } else if (timeDiff.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (timeDiff.inHours >= 2) {
      return '${timeDiff.inHours} hours ago';
    } else if (timeDiff.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (timeDiff.inMinutes >= 2) {
      return '${timeDiff.inMinutes} minutes ago';
    } else if (timeDiff.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (timeDiff.inSeconds >= 3) {
      return '${timeDiff.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
