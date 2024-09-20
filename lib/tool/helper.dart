/*
 * *
 *  * helper.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 19:09
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 19:07
 *
 */

import 'dart:io';

import 'package:astronacci/model/app/singleton_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  Future exitApp() {
    return Platform.isIOS ? exit(0) : SystemNavigator.pop(animated: true);
  }

  Future jumpToPage(BuildContext context, {required Widget page}) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page))
        .then((_) {
      SingletonModel.shared.context = context;
    });
  }

  Future moveToPage(BuildContext context, {required Widget page}) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => page));
  }

  Future jumpToPageWithoutAnim(BuildContext context, {required Widget page}) {
    return Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  Future moveToPageWithoutAnim(BuildContext context, {required Widget page}) {
    return Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  void backToRootPage(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void showToast(
    String msg, {
    Toast? length,
    ToastGravity? gravity,
    Color? bgColor,
    Color? textColor,
    double? size,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: bgColor ?? Colors.black,
      textColor: textColor ?? Colors.white,
      fontSize: size ?? 16.0,
    );
  }

  Future<void> launch(String url, {Function()? onError}) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (onError != null) {
        onError();
        return;
      }
      throw Exception('Could not launch $url');
    }
  }

  Future destroySession() async {
    SingletonModel.shared.destroy();
  }

  void copyClipboard(String data, {required Function() onCopied}) {
    Clipboard.setData(ClipboardData(text: data)).then((_) {
      onCopied();
    });
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(this);
  }
}

extension StateHelper on State {
  String className() {
    return toString().split("#").first;
  }
}

extension StringHelper on String? {
  bool isNullOrEmpty() {
    return (this ?? "").isEmpty;
  }

  bool isNotNullOrEmpty() {
    return (this ?? "").isNotEmpty;
  }

  bool isChanged({required String? from, bool allowEmpty = false}) {
    if (this == from) {
      return false;
    }

    // String different
    if (allowEmpty) {
      return true;
    }

    // not allow empty
    if (isNullOrEmpty()) {
      return false;
    }

    // not null or empty
    return true;
  }
}

extension DateFormatter on DateFormat {
  String? tryFormat(DateTime? date) {
    if (date == null) {
      return null;
    }

    return format(date);
  }
}

extension FirstWhereExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension IndexWhereExt<T> on List<T> {
  /// The index of the first element satisfying [test], or `null` if there are none.
  int? indexWhereOrNull(bool Function(T element) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) return i;
    }
    return null;
  }
}

extension DateTimeAge on DateTime? {
  int get age {
    if (this == null) {
      return 0;
    }

    DateTime now = DateTime.now();
    DateTime bd = this!;
    int yo = now.year - bd.year - 1;
    if (bd.month - now.month <= 0) {
      if (bd.day - now.day <= 0) {
        yo += 1;
      }
    }

    return yo;
  }
}
