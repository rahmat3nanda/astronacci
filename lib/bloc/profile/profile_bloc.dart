/*
 * *
 *  * profile_bloc.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:53
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 17:53
 *
 */

import 'package:astronacci/bloc/profile/profile_event.dart';
import 'package:astronacci/bloc/profile/profile_state.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/model/response_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/tool/user_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:astronacci/bloc/profile/profile_event.dart';
export 'package:astronacci/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  DocumentSnapshot? _lastDocument;

  ProfileBloc(ProfileInitialState super.initialState) {
    on<ProfileListEvent>(_list);
    on<ProfileDetailEvent>(_detail);
  }

  void _list(ProfileListEvent event, Emitter<ProfileState> state) async {
    state(ProfileInitialState());
    try {
      if (event.page == 0) {
        _lastDocument = null;
      }

      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection(AppString.remote.users)
          .orderBy("uid")
          .limit(event.size);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      List<UserModel> data = List<UserModel>.from(
          snapshot.docs.map((x) => UserModel.fromJson(x.data())));

      for (UserModel user in data) {
        user.imageUrl = await UserImage.shared.image(user.images ?? "");
      }

      _lastDocument = snapshot.docs.last;

      AppLog.print(data);

      state(ProfileListSuccessState(data: data, page: event.page));
    } catch (e) {
      AppLog.print(e);
      state(ProfileListFailedState(
        data: ResponseModel(
          code: e.toString().toLowerCase().contains("no element") ? 200 : 500,
          message: e,
        ),
        page: event.page,
      ));
    }
  }

  void _detail(ProfileDetailEvent event, Emitter<ProfileState> state) async {
    state(ProfileInitialState());
    try {
      DocumentSnapshot<Map<String, dynamic>> map = await FirebaseFirestore
          .instance
          .collection(AppString.remote.users)
          .doc(event.uid)
          .get();

      UserModel user = UserModel.fromJson(map.data()!);
      user.imageUrl = await UserImage.shared.image(user.images ?? "");

      AppLog.print(user);

      state(ProfileDetailSuccessState(user));
    } catch (e) {
      state(ProfileDetailFailedState(ResponseModel(code: 404, message: e)));
    }
  }
}
