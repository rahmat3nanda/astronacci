/*
 * *
 *  * splash_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 19:38
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 19:38
 *
 */

import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/page/login_page.dart';
import 'package:astronacci/page/main_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late SingletonModel _model;
  late AuthBloc _bloc;
  late Helper _helper;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _bloc = BlocProvider.of<AuthBloc>(context);
    _helper = Helper();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _setup();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setup() async {
    await _controller.forward();
    _bloc.add(const AuthLoadEvent());
  }

  void _route() {
    Widget target = _model.isLoggedIn == true && _model.user != null
        ? const MainPage()
        : const LoginPage();

    _helper.moveToPage(context, page: target);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) {
        if (s is AuthLoadSuccessState) {
          _model = SingletonModel.withContext(context);
          _route();
        } else if (s is AuthLoadFailedState) {
          _model = SingletonModel.withContext(context);
          _route();
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) {
          return Scaffold(
            body: FadeTransition(
              opacity: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcon.astronacci,
                  width: 172,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
