/*
 * *
 *  * button_action_model.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:34
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/12/2024, 02:09
 *
 */

import 'package:flutter/material.dart';

class ButtonActionModel {
  Widget child;
  Function(BuildContext context) onTap;

  ButtonActionModel({required this.child, required this.onTap});
}
