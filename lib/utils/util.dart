import 'dart:developer';

import 'package:intl/intl.dart';

String? formatStrDate(String date) {
  if (date == '0001-01-01') {
    return null; // Return null for invalid or default dates
  }
  try {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(parsedDate); // Removed time
    return formattedDate;
  } catch (e) {
    return '';
  }
}

void showLog(String msg) {
  // log('\x1B[32m$msg\x1B[0m');
}

bool? isAppStartTimeIsPassed(String date) {
  if (date == '0001-01-01') {
    return false; // Return null for invalid or default dates
  }
  try {
    DateTime parsedDate = DateTime.parse(date);
    if (parsedDate.year > 1754) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

String? formatStrTime(String time) {
  try {
    if (time == "1753-01-01T00:00:00") return "";
    DateTime parsedTime = DateTime.parse(time);
    String formattedTime = DateFormat(
      'hh:mm a',
    ).format(parsedTime); // 12-hour format with AM/PM
    return formattedTime;
  } catch (e) {
    return '';
  }
}

String convertTo12HourFormat(String isoDateTime) {
  if (isoDateTime.isEmpty) return "";
  // Extract the time part from the ISO 8601 format
  String time24 = isoDateTime.split('T')[1]; // Get the "00:00:00" part

  // Split the string to extract hours, minutes, and seconds
  List<String> parts = time24.split(':');
  int hour24 = int.parse(parts[0]);
  int minute24 = int.parse(parts[1]);

  String period = "AM";
  int hour12 = hour24;

  // Determine if it's AM or PM
  if (hour24 >= 12) {
    period = "PM";
  }
  // Convert 24-hour time to 12-hour time
  if (hour24 > 12) {
    hour12 = hour24 - 12;
  } else if (hour24 == 0) {
    hour12 = 12;
  }

  String minute = minute24.toString().padLeft(2, '0');

  return "$hour12:$minute $period";
}
