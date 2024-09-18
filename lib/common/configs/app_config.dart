/*
 * *
 *  * app_config.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:31
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 18:29
 *
 */

import 'package:astronacci/model/app/app_version_model.dart';
import 'package:astronacci/model/app/scheme_model.dart';

class AppConfig {
  static AppConfig? _config;

  factory AppConfig() => _config ??= AppConfig._internal();

  AppConfig._internal();

  static AppConfig get shared => _config ??= AppConfig._internal();

  late AppScheme scheme;
  late String baseUrlApi;
  late AppVersionModel version;

  void initialize({
    required AppScheme scheme,
    required String baseUrlApi,
    required AppVersionModel version,
  }) {
    this.scheme = scheme;
    this.baseUrlApi = baseUrlApi;
    this.version = version;
  }
}
