

/*
 * *
 *  * app_icon.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:36
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/10/2024, 19:39
 *
 */

const _path = "asset/icons/";

class AppIcon {
  static String astronacci = "astronacci.svg".withIconPath();
}

extension AppIconString on String {
  String withIconPath({bool withPrefix = true, String group = ""}) {
    return "$_path$group${group.isEmpty ? "" : "/"}${withPrefix ? "ic_${group.isEmpty ? "" : "${group}_"}" : ""}$this";
  }
}
