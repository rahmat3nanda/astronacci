/*
 * *
 *  * profile_list_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 18:10
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 18:10
 *  
 */

import 'package:astronacci/bloc/profile/profile_bloc.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/error_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/page/profile/profile_detail_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/image_network_widget.dart';
import 'package:astronacci/widget/reload_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileListPage extends StatefulWidget {
  final ScrollController? scrollController;

  const ProfileListPage({super.key, this.scrollController});

  @override
  State<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends State<ProfileListPage> {
  late Helper _helper;
  late ProfileBloc _bloc;

  late RefreshController _cRefresh;
  late int _page;
  List<UserModel>? _data;
  ErrorModel? _error;
  late bool _onLoad;

  @override
  void initState() {
    super.initState();
    SingletonModel.withContext(context);
    _helper = Helper();
    _bloc = BlocProvider.of<ProfileBloc>(context);
    _cRefresh = RefreshController(initialRefresh: false);
    _page = 0;
    _onLoad = false;
    _onRefresh();
  }

  void _onRefresh() {
    _page = 0;
    _onLoad = true;
    _getData(_page);
    _cRefresh.refreshCompleted();
  }

  void _getData(int page) {
    _error = null;
    _bloc.add(ProfileListEvent(page: page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) {
        if (s is ProfileListSuccessState) {
          _onLoad = false;
          _page = s.page;
          if (s.page == 0) {
            _data = s.data;
          } else {
            _data ??= [];
            _data!.addAll(s.data);
          }
        } else if (s is ProfileListFailedState) {
          _onLoad = false;
          _cRefresh.loadComplete();

          if ((_data?.isNotEmpty ?? false) && s.data.code != 200) {
            _helper.showToast("Failure to load data");
          }
          _error = ErrorModel(
            event: ProfileListEvent(page: s.page),
            error: s.data.message.toString(),
          );
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) {
          return Scaffold(
            appBar: AppBar(title: const Text("Data")),
            body: SafeArea(
              child: SmartRefresher(
                enablePullDown:
                    (_error == null || (_error != null && _page > 0)) &&
                        !_onLoad,
                enablePullUp: _error == null,
                header: WaterDropMaterialHeader(
                  backgroundColor: AppColor.primary,
                  color: AppColor.secondary,
                ),
                footer: CustomFooter(
                  builder: (context, status) => SpinKitWave(
                    color: AppColor.primary,
                    size: 32,
                  ),
                ),
                controller: _cRefresh,
                onRefresh: _onRefresh,
                onLoading: () => setState(() {
                  _getData(_page + 1);
                  _cRefresh.loadComplete();
                }),
                child: _stateView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stateView() {
    if (_onLoad) {
      return Column(
        children: [
          Expanded(
            child: SpinKitWaveSpinner(
              color: AppColor.primaryLight,
              trackColor: AppColor.primary,
              waveColor: AppColor.secondary,
              size: 64,
            ),
          ),
        ],
      );
    }

    if (_error != null && _page == 0) {
      return Column(
        children: [
          Expanded(
            child: ReloadDataWidget(
              error: "Unable to load data",
              onReload: _onRefresh,
            ),
          ),
        ],
      );
    }

    return _mainView();
  }

  Widget _mainView() {
    if (_data?.isEmpty ?? true) {
      return const Center(
        child: Text("No data yet"),
      );
    }

    double imageSize = 100.0;
    int gridCount = (MediaQuery.of(context).size.width - 152) ~/ imageSize;
    return GridView.builder(
      controller: widget.scrollController,
      itemCount: _data?.length ?? 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (c, i) {
        UserModel d = _data![i];
        return Card(
          child: InkWell(
            splashColor: AppColor.secondary,
            borderRadius: BorderRadius.circular(12),
            onTap: () => _helper.jumpToPage(
              context,
              page: ProfileDetailPage(
                user: d,
                onUserUpdated: (u) => setState(() {
                  _data![i] = u;
                }),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 7,
                  child: ImageNetworkWidget(
                    url: d.imageUrl ?? "",
                    clickable: false,
                    radius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.fullName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(d.gender?.name.toUpperCase() ?? "-"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
