

/*
 * *
 *  * always_disabled_focus_node.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 15:51
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 07/12/2024, 03:27
 *
 */

import 'package:flutter/material.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}