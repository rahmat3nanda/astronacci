/*
 * *
 *  * app_locale.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:32
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/10/2024, 19:39
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocale {
  static AppLocale? _config;

  factory AppLocale() => _config ??= AppLocale._internal();

  AppLocale._internal();

  static AppLocale get shared => _config ??= AppLocale._internal();

  List<LocalizationsDelegate> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  List<Locale> supports = [
    const Locale('en'),
    const Locale('id'),
  ];
}
