/*
 * *
 *  * app_alert_dialog.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:35
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/12/2024, 17:46
 *
 */

import 'dart:io';

import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/button_action_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final List<ButtonActionModel> actions;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  State<AppAlertDialog> createState() => _AppAlertDialogState();
}

class _AppAlertDialogState extends State<AppAlertDialog> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title, style: const TextStyle(fontSize: 16.0)),
        content: Text(widget.message, style: const TextStyle(fontSize: 14.0)),
        actions: List.generate(
          widget.actions.length,
          (i) => CupertinoDialogAction(
            child: widget.actions[i].child,
            onPressed: () => widget.actions[i].onTap(context),
          ),
        ),
      );
    }
    return AlertDialog(
      title: Text(widget.title, style: const TextStyle(fontSize: 16.0)),
      content: Text(widget.message, style: const TextStyle(fontSize: 14.0)),
      actions: List.generate(
        widget.actions.length,
        (i) => MaterialButton(
          child: widget.actions[i].child,
          onPressed: () => widget.actions[i].onTap(context),
        ),
      ),
    );
  }
}

Future openAppAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  List<ButtonActionModel> actions = const [],
  bool dismissible = true,
}) {
  return showGeneralDialog(
    barrierLabel: "App Alert Dialog",
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Theme(
        data: AppTheme.main(context),
        child: AppAlertDialog(
          title: title,
          message: message,
          actions: actions,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: child,
      );
    },
  );
}
