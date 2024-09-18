/*
 * *
 *  * singleton_model.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 19:05
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/12/2024, 18:59
 *
 */

import 'package:astronacci/model/user_model.dart';
import 'package:flutter/material.dart';

class SingletonModel {
  static SingletonModel? _singleton;

  factory SingletonModel() => _singleton ??= SingletonModel._internal();

  SingletonModel._internal();

  static SingletonModel withContext(BuildContext context) {
    _singleton ??= SingletonModel._internal();
    _singleton!.context = context;

    return _singleton!;
  }

  static SingletonModel get shared => _singleton ??= SingletonModel._internal();

  BuildContext? context;
  UserModel? user;
  bool? isLoggedIn;

  void destroy() {
    _singleton = null;
  }
}
