import 'package:flutter/material.dart';

class Utils {
  static String timeToString(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  static TimeOfDay stringToTime(String timeStr) {
    List<String> hourAndMinute = timeStr.split(":");
    return TimeOfDay(hour: int.parse(hourAndMinute[0]), minute: int.parse(hourAndMinute[1]));
  }
  
  static DateTime mergeDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
    );
  }
}