/*
 * *
 *  * app_version_model.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:31
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 01/12/2024, 20:53
 *
 */

class AppVersionModel {
  late String name;
  late int number;

  AppVersionModel({required this.name, required this.number});

  factory AppVersionModel.empty() => AppVersionModel(name: "1.0.0", number: 1);

  @override
  String toString() => "$name($number)";
}
