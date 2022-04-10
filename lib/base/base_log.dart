import 'dart:async';
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void fLog(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) {
    return;
  }
  log(message, time: time, sequenceNumber: sequenceNumber, level: level, name: name, zone: zone, error: error);
}

void logFirebaseError(Object exception, StackTrace trace, {bool isFatal = false, String module = "app"}) {
  FirebaseCrashlytics.instance.recordError(exception, trace, reason: module, fatal: isFatal);
}
