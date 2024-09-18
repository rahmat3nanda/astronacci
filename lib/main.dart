/*
 * *
 *  * main.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 19:38
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 18:29
 *
 */

import 'package:astronacci/app.dart';
import 'package:astronacci/bloc/observer.dart';
import 'package:astronacci/common/configs.dart';
import 'package:astronacci/common/configs/firebase_options.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/model/app/app_version_model.dart';
import 'package:astronacci/model/app/scheme_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  AppLog.debugMode = true;
  Bloc.observer = Observer();
  AppConfig.shared.initialize(
    scheme: AppScheme.dev,
    version: AppVersionModel.empty(),
  );
  runApp(const App());
}
