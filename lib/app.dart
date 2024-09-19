/*
 * *
 *  * app.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 19:40
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 19:40
 *
 */

import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/bloc/profile/profile_bloc.dart';
import 'package:astronacci/common/configs.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/app_version_model.dart';
import 'package:astronacci/model/app/scheme_model.dart';
import 'package:astronacci/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  void _getInfo() {
    PackageInfo.fromPlatform().then((i) {
      setState(() {
        AppConfig.shared.version = AppVersionModel(
          name: i.version,
          number: int.tryParse(i.buildNumber) ?? 1,
        );
      });
    }).catchError((e) {
      _getInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(AuthInitialState()),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc(ProfileInitialState()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(
          children: [
            MaterialApp(
              localizationsDelegates: AppLocale.shared.delegates,
              supportedLocales: AppLocale.shared.supports,
              debugShowCheckedModeBanner: false,
              title: AppString.appName,
              theme: AppTheme.main(context),
              home: const SplashPage(),
            ),
            if (AppConfig.shared.scheme == AppScheme.dev)
              IgnorePointer(
                ignoring: true,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Opacity(
                    opacity: .3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: double.infinity),
                        Text(
                          "DEV\n${AppConfig.shared.version.toString()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
