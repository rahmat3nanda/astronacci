/*
 * *
 *  * user_image.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 18:33
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 18:33
 *
 */

import 'package:firebase_storage/firebase_storage.dart';

class UserImage {
  static UserImage? _singleton;

  factory UserImage() => _singleton ??= UserImage._internal();

  UserImage._internal();

  static UserImage get shared => _singleton ??= UserImage._internal();

  Map<String, dynamic> _data = {};

  void clear() {
    _data = {};
  }

  Future<String?> image(String from) async {
    if (_data[from] != null) {
      return _data[from];
    }

    try {
      String path = from.split("/").first;
      String file = from.split("/").last;

      String url =
          await FirebaseStorage.instance.ref(path).child(file).getDownloadURL();

      _data[from] = url;

      return url;
    } catch (_) {
      return null;
    }
  }
}
