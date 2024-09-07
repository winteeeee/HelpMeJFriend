import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/entity/entity.dart';
import 'package:help_me_j_friend/persistence/entity/plan.dart';
import 'package:help_me_j_friend/persistence/entity/position.dart';
import 'package:help_me_j_friend/persistence/entity/task.dart';

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

  static String dateToTimeString(DateTime date) {
    String hourString = date.hour.toString();
    String minuteString = date.minute.toString();

    String hour = hourString.length == 1 ? "0$hourString" : hourString;
    String minute = minuteString.length == 1 ? "0$minuteString" : minuteString;

    return "$hour:$minute";
  }

  static TimeOfDay dateToTime(DateTime date) {
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  static String entityToBase64(Entity e) {
    return base64Encode(utf8.encode(jsonEncode(e.toMap())));
  }

  static Map<String, dynamic> base64ToMap(String base64) {
    return jsonDecode(utf8.decode(base64Decode(base64)));
  }
}