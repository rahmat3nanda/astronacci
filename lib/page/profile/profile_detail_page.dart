/*
 * *
 *  * profile_detail_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/20/2024, 11:58
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/20/2024, 11:58
 *
 */

import 'package:astronacci/bloc/profile/profile_bloc.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/page/profile/profile_edit_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/image_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileDetailPage extends StatefulWidget {
  final UserModel user;
  final Function(UserModel user) onUserUpdated;

  const ProfileDetailPage({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late SingletonModel _model;
  late ProfileBloc _bloc;
  late Helper _helper;

  late RefreshController _cRefresh;
  late UserModel _data;
  late bool _onLoad;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _bloc = BlocProvider.of<ProfileBloc>(context);
    _helper = Helper();
    _cRefresh = RefreshController(initialRefresh: false);
    _data = widget.user;
    _onLoad = false;
  }

  void _onRefresh() {
    _getData();
    _cRefresh.refreshCompleted();
  }

  void _getData() {
    _onLoad = true;
    _bloc.add(ProfileDetailEvent(_data.uid));
  }

  void _onEdit() async {
    await _helper.jumpToPage(context, page: ProfileEditPage());
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) {
        if (s is ProfileDetailSuccessState) {
          _onLoad = false;
          if (s.data.uid == _data.uid) {
            _data = s.data;
            widget.onUserUpdated(s.data);
          }
        } else if (s is ProfileDetailFailedState) {
          _onLoad = false;
          if (s.uid == _data.uid) {
            _helper.showToast("Failure refresh data");
          }
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              actions: [
                if (_data.uid == _model.user?.uid)
                  IconButton(
                    onPressed: _onEdit,
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
        Align(
          alignment: Alignment.center,
          child: ImageNetworkWidget(
            width: 108,
            height: 108,
            border: Border.all(color: AppColor.primary, width: 4),
            fit: BoxFit.scaleDown,
            shape: BoxShape.circle,
            url: _data.imageUrl ?? "",
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _data.fullName ?? "-",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          _data.gender?.name.toUpperCase() ?? "-",
          textAlign: TextAlign.center,
        ),
        Text(
          "${_data.birthDate.age} y.o",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        _itemView(
          title: "Email",
          value: _data.email,
          onTap: () => _helper.launch("mailto:${_data.email}"),
        ),
        _itemView(title: "Birth Place", value: _data.birthPlace),
        _itemView(title: "Religion", value: _data.religion?.name),
      ],
    );
  }

  Widget _itemView({
    required String title,
    required String? value,
    Function()? onTap,
  }) {
    bool clickable = onTap != null && value != null;
    return Row(
      children: [
        Text(title),
        const Text(" : "),
        InkWell(
          child: Text(
            value ?? "-",
            style: TextStyle(color: clickable ? Colors.blue : null),
          ),
          onTap: () {
            if (clickable) {
              onTap();
            }
          },
        ),
      ],
    );
  }
}
