/*
 * *
 *  * profile_state.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:44
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 17:44
 *  
 */

import 'package:astronacci/model/response_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileListSuccessState extends ProfileState {
  final List<UserModel> data;
  final int page;

  const ProfileListSuccessState({required this.data, required this.page});
}

class ProfileListFailedState extends ProfileState {
  final ResponseModel data;
  final int page;

  const ProfileListFailedState({required this.data, required this.page});
}

class ProfileDetailSuccessState extends ProfileState {
  final UserModel data;

  const ProfileDetailSuccessState(this.data);
}

class ProfileDetailFailedState extends ProfileState {
  final ResponseModel data;
  final String uid;

  const ProfileDetailFailedState({required this.data, required this.uid});
}
