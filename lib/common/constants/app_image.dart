/*
 * *
 *  * app_image.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:36
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/10/2024, 21:50
 *
 */

const _path = "asset/images/";

class AppImage {
  static String astronacci = "astronacci.png".withImagePath();
  static String astronacciFill = "astronacci_fill.png".withImagePath();
}

extension AppImageString on String {
  String withImagePath({bool withPrefix = true}) {
    return "$_path${withPrefix ? "img_" : ""}$this";
  }
}
