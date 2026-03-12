// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension CustomDateTimeRange on DateTimeRange {
  
  String endpointFilter() {
    final filter =
        'from=${start.parseStart.toIso8601String()}-03:00&'
        'to=${end.parseEnd.toIso8601String()}-03:00';
    return filter;
  }

  String queryFilter(String startParam, String endParam) {
    return "$startParam=${adjustedPeriod.start.toIso8601String()}-03:00&$endParam=${adjustedPeriod.end.toIso8601String()}-03:00";
  }

  String get parsePeriod {
    return "De ${start.toDefaultDate} a ${end.toDefaultDate}";
  }  

  DateTime toEndDay() {
    return end..add(const Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
  }

  DateTimeRange get adjustedPeriod {
    return DateTimeRange(
      start: DateTime(start.year, start.month, start.day, 0, 0, 0, 000), 
      end: DateTime(end.year, end.month, end.day, 23, 59, 59, 999)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
    };
  }

}


extension FormatDate on DateTime {
  

  DateTime get parseStart {
    return DateTime(year, month, day, 0, 0, 0, 000);
  }

  DateTime get parseEnd {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  String get parseMonth {
    return switch (month) {
      DateTime.january => "Janeiro",
      DateTime.february => "Fevereiro",
      DateTime.march => "Março",
      DateTime.april => "Abril",
      DateTime.may => "Maio",
      DateTime.june => "Junho",
      DateTime.july => "Julho",
      DateTime.august => "Agosto",
      DateTime.september => "Setembro",
      DateTime.october => "Outubro",
      DateTime.november => "Novembro",
      DateTime.december => "Dezembro",
      _ => "",
    };
  }

  String get parseWeekDay {
    return switch (weekday) {
      1 => "Segunda-feira",
      2 => "Terça-feira",
      3 => "Quarta-feira",
      4 => "Quinta-feira",
      5 => "Sexta-feira",
      6 => "Sábado",
      _ => "Domingo",
    };
  }

  String get simplePeriodDescription {
    final now = DateTime.now();
    final hourAnMinute = DateFormat("HH:mm").format(toLocal());
    if (day == now.day) return "Hoje as $hourAnMinute";
    final diff = now.parseStart.difference(parseEnd);
    return switch (diff.inHours) {
      <= 24 => "Ontem as $hourAnMinute",
      > 24 && <= 72 => "$parseWeekDay $hourAnMinute",
      _ => toDefaultDateWithHour,
    };
  }

  String get toDefaultDate {
    return DateFormat('dd/MM/yyyy').format(toLocal());
  }

  String get toDefautDateFull => DateFormat('dd/MM/yyyy HH:mm:ss').format(toLocal());

  String get hourMinutesAndSeconds => DateFormat("HH:mm:ss").format(toLocal());

  String get toDefaultDateWithHour {
    return DateFormat('dd/MM/yyyy HH:mm').format(toLocal());
  }

  String get toDefaultDateWithHourNoTmz {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  DateTime nextDateIfSunday() {
    if (weekday == DateTime.sunday) {
      return add(const Duration(days: 1));
    }
    return this;
  }

  DateTimeRange get setPeriod {
    return DateTimeRange(
      start: DateTime(year, month, day, 0, 0, 0, 000), 
      end: DateTime(year, month, day, 23, 59, 59, 999)
    );
  }

  DateTime get withTimeZone => toUtc();

  bool get isLeapYear {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else if (year % 400 != 0) {
      return false;
    } else {
      return true;
    }
  }

  DateTimeRange get parsePeriod {
    // final now = DateTime.now();
    DateTimeRange range;
    DateTimeRange setPeriod(int lastDay) => DateTimeRange(
      start: DateTime(year, month, 1),
      end: DateTime(year, month, lastDay),
    );
    switch (month) {
      case DateTime.april:
      case DateTime.june:
      case DateTime.september:
      case DateTime.november:
        range = setPeriod(30);
        break;
      case DateTime.february:
        range = setPeriod(isLeapYear ? 29 : 28);
        break;
      default:
        range = setPeriod(31);
    }
    return range.adjustedPeriod;
  }

  List<DateTimeRange> get lastThreeMonthPeriods {
    final today = DateTime.now();
    final middleMonth = DateTime(today.year, today.month, 15);
    DateTime getPeriod(DateTime date, int days) => date.add(Duration(days: -days));
    final dt = [
      getPeriod(middleMonth, 30).parsePeriod,
      getPeriod(middleMonth, 60).parsePeriod,
      getPeriod(middleMonth, 90).parsePeriod,
    ];
    return dt;
  }
}

extension CheckField on Map {

  bool isString(String key) {
    if (this[key] is String) {
      return true;
    }
    return false;
  }
}

extension DurationParser on Duration {
  String inProgressTime() {
    if (inHours > 0) {
      return "$inHours hora(s) ${inMinutes.remainder(60) > 0 ? "e ${inMinutes.remainder(60)} minuto(s)" : ""}";
    }
    if (inMinutes > 0) {
      return "$inMinutes minuto(s) ${inSeconds.remainder(60) > 0 ? "e ${inSeconds.remainder(60)} segundo(s)" : ""}";
    }
    return "$inSeconds segundo(s)";
  }
}

extension TextFormat on String {
  String removerAcentos() {
    const comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    const semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < comAcentos.length; i++) {
      replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }
    return this;
  }

  bool get hasContent {
    return trim().isNotEmpty;
  }

  double get parsedDouble => double.tryParse(replaceAll(',', ".")) ?? 0.0;

  String get clearedCgc => replaceAll('.', '').replaceAll('-', '').trimRight();

  String clearPhone() {
    return 
      replaceAll('(', '').
      replaceAll(')', '').
      replaceAll('-', '')
      .replaceAll(' ', '');
  }

  String get toPhoneNumberFormat {
    return characters.mapIndexed((i, c) {
      if (i == 0)  return "($c";      
      if (i == 1) return "$c) ";
      if (i == 6) return "$c-";
      return c;
    }).join();
  }

  Uint8List? get toBytes {
    try {
      if (!hasContent) {
        return null;
      }

      return Uint8List.fromList(base64Decode(this));
    } catch (_) {
      return null;
    }
  }
}

extension Sized on num {
  SizedBox get verticalBox {
    return SizedBox(
      height: toDouble(),
    );
  }

  SizedBox get horizontalBox {
    return SizedBox(
      width: toDouble(),
    );
  }

  RenderObjectWidget get sliverVertialBox {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: toDouble(),
      ),
    );
  }

  BorderRadius get borderRadius {
    return BorderRadius.all(Radius.circular(toDouble()));
  }

  RenderObjectWidget get sliverHorizontalBox {
    return SizedBox(
      width: toDouble(),
    );
  }

  String get parsedToController => toStringAsFixed(2).replaceAll('.', ',');
  
  String get intOrDouble {
    return this % 1 == 0 ? toInt().toString() : toStringAsFixed(1);
  }

  bool get hasValue => this > 0;
}