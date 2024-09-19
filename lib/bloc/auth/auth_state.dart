/*
 * *
 *  * auth_state.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:40
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/11/2024, 13:31
 *
 */

import 'package:astronacci/model/response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadSuccessState extends AuthState {
  const AuthLoadSuccessState();
}

class AuthLoadFailedState extends AuthState {
  final ResponseModel data;

  const AuthLoadFailedState(this.data);
}

class AuthLoginSuccessState extends AuthState {
  const AuthLoginSuccessState();
}

class AuthLoginFailedState extends AuthState {
  final ResponseModel data;

  const AuthLoginFailedState(this.data);
}

class AuthRegisterSuccessState extends AuthState {
  const AuthRegisterSuccessState();
}

class AuthRegisterFailedState extends AuthState {
  final ResponseModel data;

  const AuthRegisterFailedState(this.data);
}

class AuthResetPasswordSuccessState extends AuthState {
  const AuthResetPasswordSuccessState();
}

class AuthResetPasswordFailedState extends AuthState {
  final ResponseModel data;

  const AuthResetPasswordFailedState(this.data);
}

class AuthLogoutSuccessState extends AuthState {
  const AuthLogoutSuccessState();
}

class AuthLogoutFailedState extends AuthState {
  final ResponseModel data;

  const AuthLogoutFailedState(this.data);
}
