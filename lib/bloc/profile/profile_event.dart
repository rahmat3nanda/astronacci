/*
 * *
 *  * profile_event.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:51
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 17:51
 *  
 */

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileListEvent extends ProfileEvent {
  final int page;
  final int size;
  final String name;

  const ProfileListEvent({required this.page, this.size = 10, this.name = ""});

  @override
  String toString() {
    return 'ProfileListEvent{page: $page, size: $size, name: $name}';
  }
}

class ProfileDetailEvent extends ProfileEvent {
  final String uid;

  const ProfileDetailEvent(this.uid);

  @override
  String toString() {
    return 'ProfileDetailEvent{uid: $uid}';
  }
}
