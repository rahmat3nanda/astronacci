/*
 * *
 *  * auth_bloc.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:40
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/11/2024, 17:08
 *
 */

import 'package:astronacci/model/response_model.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astronacci/bloc/auth/auth_event.dart';
import 'package:astronacci/bloc/auth/auth_state.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:rcache_flutter/rcache.dart';

export 'package:astronacci/bloc/auth/auth_event.dart';
export 'package:astronacci/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Helper _helper = Helper();

  AuthBloc(AuthInitialState super.initialState) {
    on<AuthLoadEvent>(_load);
    on<AuthLoginEvent>(_login);
    on<AuthRegisterEvent>(_register);
    on<AuthLogoutEvent>(_logout);
  }

  void _load(AuthLoadEvent event, Emitter<AuthState> state) async {
    state(AuthInitialState());
    try {
      User? current = FirebaseAuth.instance.currentUser;

      Map<String, dynamic>? map = await RCache.credentials.readMap(
        key: RCacheKey(AppString.cache.user),
      );

      UserModel? user;
      if (map != null) {
        user = UserModel.fromJson(map);
      }

      if (current?.uid != user?.uid) {
        user = null;
        await RCache.credentials.remove(key: RCacheKey(AppString.cache.user));
      }

      SingletonModel.shared.user = user;
      SingletonModel.shared.isLoggedIn = user != null;

      state(const AuthLoadSuccessState());
    } catch (e) {
      SingletonModel.shared.user = null;
      SingletonModel.shared.isLoggedIn = false;
      state(AuthLoadFailedState(ResponseModel(code: 401, message: e)));
    }
  }

  void _login(AuthLoginEvent event, Emitter<AuthState> state) async {
    state(AuthInitialState());
    try {
      UserCredential c = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      DocumentSnapshot<Map<String, dynamic>> map = await FirebaseFirestore
          .instance
          .collection(AppString.remote.users)
          .doc(c.user!.uid)
          .get();

      UserModel user = UserModel.fromJson(map.data()!);
      await RCache.credentials.saveMap(
        user.toJson(),
        key: RCacheKey(AppString.cache.user),
      );

      SingletonModel.shared.user = user;
      SingletonModel.shared.isLoggedIn = true;

      state(const AuthLoginSuccessState());
    } catch (e) {
      SingletonModel.shared.user = null;
      SingletonModel.shared.isLoggedIn = false;
      state(AuthLoginFailedState(ResponseModel(code: 401, message: e)));
    }
  }

  void _register(AuthRegisterEvent event, Emitter<AuthState> state) async {
    state(AuthInitialState());
    try {
      UserCredential c =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      UserModel user = UserModel(
        uid: c.user!.uid,
        email: event.email,
        fullName: event.fullName,
        religion: event.religion,
        gender: event.gender,
        birthPlace: event.birthPlace,
        birthDate: event.birthDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection(AppString.remote.users)
          .doc(c.user!.uid)
          .update(user.toJson());

      await RCache.credentials.saveMap(
        user.toJson(),
        key: RCacheKey(AppString.cache.user),
      );

      SingletonModel.shared.user = user;
      SingletonModel.shared.isLoggedIn = true;

      state(const AuthRegisterSuccessState());
    } catch (e) {
      SingletonModel.shared.user = null;
      SingletonModel.shared.isLoggedIn = false;
      state(AuthRegisterFailedState(ResponseModel(code: 401, message: e)));
    }
  }

  void _logout(AuthLogoutEvent event, Emitter<AuthState> state) async {
    state(AuthInitialState());
    try {
      await FirebaseAuth.instance.signOut();
      await RCache.credentials.remove(key: RCacheKey(AppString.cache.user));
      _helper.destroySession();
      state(const AuthLogoutSuccessState());
    } catch (e) {
      _helper.destroySession();
      state(AuthLogoutFailedState(ResponseModel(code: 401, message: e)));
    }
  }
}
