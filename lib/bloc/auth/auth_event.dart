/*
 * *
 *  * auth_event.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:40
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/11/2024, 13:31
 *
 */

import 'package:astronacci/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoadEvent extends AuthEvent {
  const AuthLoadEvent();

  @override
  String toString() {
    return "AuthLoadEvent{}";
  }
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  String toString() {
    return "AuthLoginEvent{email: $email, password: $password}";
  }
}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String religion;
  final UserGenderModel gender;
  final String birthPlace;
  final DateTime birthDate;

  const AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.religion,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
  });

  @override
  String toString() {
    return 'AuthRegisterEvent{email: $email, password: $password, fullName: $fullName, religion: $religion, gender: $gender, birthPlace: $birthPlace, birthDate: $birthDate}';
  }
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();

  @override
  String toString() {
    return "AuthLogoutEvent{}";
  }
}
