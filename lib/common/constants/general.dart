/*
 * *
 *  * general.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:37
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 18:29
 *
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:astronacci/common/constants/app_string.dart';

class AppLog {
  static bool debugMode = false;
  static String tag = "[${AppString.appName.split(" ").first}]";

  static void print(dynamic data, {bool debug = false}) {
    String message = "[${DateTime.now().toUtc()}]$tag$data";
    if (debugMode || debug) {
      debugPrint(message);
    } else {
      log(message);
    }
  }
}
