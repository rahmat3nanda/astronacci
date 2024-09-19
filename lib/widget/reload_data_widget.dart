/*
 * *
 *  * reload_data_widget.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 21:48
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/12/2024, 14:02
 *
 */

import 'package:flutter/material.dart';

class ReloadDataWidget extends StatefulWidget {
  final String error;
  final Function() onReload;

  const ReloadDataWidget({
    super.key,
    required this.error,
    required this.onReload,
  });

  @override
  State<ReloadDataWidget> createState() => _ReloadDataWidgetState();
}

class _ReloadDataWidgetState extends State<ReloadDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.error,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16.0),
        MaterialButton(
          color: Colors.grey[100],
          onPressed: widget.onReload,
          child: const Text('Reload data'),
        ),
      ],
    );
  }
}
