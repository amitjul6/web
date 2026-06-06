import 'package:intl/intl.dart';

/// Local calendar-day key in `yyyy-MM-dd` form. All day-scoped data is keyed by this.
String dayKeyOf(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String todayKey() => dayKeyOf(DateTime.now());

DateTime dateFromKey(String key) => DateFormat('yyyy-MM-dd').parseStrict(key);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Friendly label: "Today" / "Yesterday" / "Tomorrow" / "Mon, Jun 8".
String friendlyDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = target.difference(today).inDays;
  if (diff == 0) return 'Today';
  if (diff == -1) return 'Yesterday';
  if (diff == 1) return 'Tomorrow';
  return DateFormat('EEE, MMM d').format(date);
}

String yesterdayKey(String key) =>
    dayKeyOf(dateFromKey(key).subtract(const Duration(days: 1)));
