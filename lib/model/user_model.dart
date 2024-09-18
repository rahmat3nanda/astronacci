/*
 * *
 *  * user_model.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:58
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/11/2024, 14:04
 *
 */

class UserModel {
  final String uid;
  final String? email;
  final String? fullName;
  final String? religion;
  final UserGenderModel? gender;
  final String? birthPlace;
  final DateTime? birthDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    this.email,
    this.fullName,
    this.religion,
    this.gender,
    this.birthPlace,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        fullName: json["full_name"],
        religion: json["religion"],
        gender: UserGenderModel.fromCode(json["gender"]),
        birthPlace: json["birth_place"],
        birthDate: json["birth_date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "full_name": fullName,
        "religion": religion,
        "gender": gender?.code,
        "birth_place": birthPlace,
        "birth_date": birthDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

enum UserGenderModel {
  male("M"),
  female("F");

  final String code;

  const UserGenderModel(this.code);

  static UserGenderModel? fromCode(String? s) {
    for (var value in values) {
      if (value.code == s) {
        return value;
      }
    }
    return null;
  }

  String? str() {
    switch (this) {
      case UserGenderModel.male:
        return "Male";
      case UserGenderModel.female:
        return "Female";
    }
  }
}
