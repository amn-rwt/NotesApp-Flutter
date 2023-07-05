//to convert weekday to String
import 'package:flutter/material.dart';

extension WeekdayToWords on int {
  String weekdayToWords() {
    if (this == 1) {
      return 'Monday';
    } else if (this == 2) {
      return 'Tuesday';
    } else if (this == 3) {
      return 'Wednesday';
    } else if (this == 4) {
      return 'Thursday';
    } else if (this == 5) {
      return 'Friday';
    } else if (this == 6) {
      return 'Saturday';
    } else if (this == 7) {
      return 'Sunday';
    } else {
      return '';
    }
  }

  String month() {
    if (this == 1) {
      return 'January';
    } else if (this == 2) {
      return 'Feburary';
    } else if (this == 3) {
      return 'March';
    } else if (this == 4) {
      return 'April';
    } else if (this == 5) {
      return 'May';
    } else if (this == 6) {
      return 'June';
    } else if (this == 7) {
      return 'July';
    } else if (this == 8) {
      return 'August';
    } else if (this == 9) {
      return 'September';
    } else if (this == 10) {
      return 'October';
    } else if (this == 11) {
      return 'November';
    } else if (this == 12) {
      return 'December';
    } else {
      return '';
    }
  }
}

extension DateFormatter on DateTime {
  String formatDate() {
    return '${weekday.weekdayToWords()}, $day ${month.month()}';
  }
}

extension TextStylingExtension on Text {
  TextStyle boldText() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }
}
