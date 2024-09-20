/*
 * *
 *  * profile_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/20/2024, 11:19
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 17:52
 *
 */

import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/bloc/profile/profile_bloc.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/page/auth/login_page.dart';
import 'package:astronacci/page/profile/profile_detail_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/button_widget.dart';
import 'package:astronacci/widget/image_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfilePage extends StatefulWidget {
  final Function(bool isLoading) showLoading;

  const ProfilePage({super.key, required this.showLoading});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SingletonModel _model;
  late AuthBloc _authBloc;
  late ProfileBloc _profileBloc;
  late Helper _helper;

  late RefreshController _cRefresh;
  late bool _onLoad;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _helper = Helper();
    _cRefresh = RefreshController(initialRefresh: false);
    _onLoad = false;
    _onRefresh(fromCache: true);
  }

  void _onRefresh({bool fromCache = false}) {
    _getData(fromCache: fromCache);
    _cRefresh.refreshCompleted();
  }

  void _getData({bool fromCache = false}) {
    _onLoad = true;

    if (fromCache && _model.user != null) {
      _onLoad = false;
      return;
    }
    _profileBloc.add(ProfileDetailEvent(_model.user?.uid ?? ""));
  }

  void _toDetail() async {
    await _helper.jumpToPage(
      context,
      page: ProfileDetailPage(
        user: _model.user!,
        onUserUpdated: (_) {},
      ),
    );
    _onRefresh();
  }

  void _onLogout() {
    widget.showLoading(true);
    _authBloc.add(const AuthLogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: _authBloc,
          listener: (c, s) {
            if (s is AuthLogoutSuccessState) {
              _helper.showToast("Success logout");
              widget.showLoading(false);
              _helper.moveToPage(context, page: const LoginPage());
            } else if (s is AuthLoginFailedState) {
              _helper.showToast("Failure logout");
              widget.showLoading(false);
            }
          },
        ),
        BlocListener(
          bloc: _profileBloc,
          listener: (c, s) {
            if (s is ProfileDetailSuccessState) {
              _onLoad = false;
              if (s.data.uid == _model.user?.uid) {
                _model.user = s.data;
              }
            } else if (s is ProfileDetailFailedState) {
              _onLoad = false;
              if (s.uid == _model.user?.uid) {
                _helper.showToast("Failure refresh data");
              }
            }
          },
        ),
      ],
      child: BlocBuilder(
        bloc: _profileBloc,
        builder: (c, s) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              actions: [
                IconButton(
                  onPressed: () {}, //TODO: Routing
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            body: SafeArea(
              child: SmartRefresher(
                enablePullDown: !_onLoad,
                enablePullUp: false,
                header: WaterDropMaterialHeader(
                  backgroundColor: AppColor.primary,
                  color: AppColor.secondary,
                ),
                footer: CustomFooter(
                  builder: (context, status) => Container(),
                ),
                controller: _cRefresh,
                onRefresh: _onRefresh,
                child: _mainView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _profileView(),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        ButtonWidget(
          onTap: _onLogout,
          width: double.infinity,
          withShadow: true,
          color: AppColor.primary,
          child: const Text(
            "Logout",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileView() {
    UserModel? d = _model.user;
    return InkWell(
      onTap: _toDetail,
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: ImageNetworkWidget(
              width: 108,
              height: 108,
              border: Border.all(color: AppColor.primary, width: 4),
              fit: BoxFit.scaleDown,
              shape: BoxShape.circle,
              url: d?.imageUrl ?? "",
            ),
          ),
          const SizedBox(height: 16),
          Text(
            d?.fullName ?? "-",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            d?.gender?.name.toUpperCase() ?? "-",
            textAlign: TextAlign.center,
          ),
          Text(
            "${d?.birthDate.age} y.o",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
