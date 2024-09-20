/*
 * *
 *  * login_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 17:39
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 16:18
 *  
 */

import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/page/auth/register_page.dart';
import 'package:astronacci/page/main_page.dart';
import 'package:astronacci/page/auth/reset_password_page.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/button_widget.dart';
import 'package:astronacci/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SingletonModel _model;
  late AuthBloc _bloc;
  late Helper _helper;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _cEmail;
  late TextEditingController _cPassword;
  late bool _obscure;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _helper = Helper();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _formKey = GlobalKey();
    _cEmail = TextEditingController();
    _cPassword = TextEditingController();
    _obscure = true;
    _isLoading = false;
  }

  void _onAuth() async {
    FocusScope.of(context).unfocus();

    if (_cEmail.text.trim().isEmpty) {
      _helper.showToast("Email cannot be empty!");
      return;
    }
    if (!_cEmail.text.trim().isValidEmail()) {
      _helper.showToast("Invalid email!");
      return;
    }

    if (_cPassword.text.trim().isEmpty) {
      _helper.showToast("Password cannot be empty!");
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _bloc.add(AuthLoginEvent(
        email: _cEmail.text.trim(),
        password: _cPassword.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) async {
        if (s is AuthLoginSuccessState) {
          _isLoading = false;
          _helper.showToast("Success Sign in");
          _model = SingletonModel.withContext(context);
          await Future.delayed(const Duration(seconds: 1));
          _helper.moveToPage(_model.context!, page: const MainPage());
        } else if (s is AuthLoginFailedState) {
          _isLoading = false;
          _helper.showToast("Failure Sign in.\n${s.data.message}");
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) {
          return LoadingOverlay(
            isLoading: _isLoading,
            color: Colors.white,
            progressIndicator: SpinKitWaveSpinner(
              color: AppColor.primaryLight,
              trackColor: AppColor.primary,
              waveColor: AppColor.secondary,
              size: 64,
            ),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(child: _mainView()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mainView() {
    Size s = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SvgPicture.asset(
            AppIcon.astronacci,
            width: 128,
          ),
        ),
        SizedBox(height: s.height * .15, width: double.infinity),
        Text(
          "Sign in",
          style: TextStyle(
            color: AppColor.primaryLight,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: s.width * .8,
          child: TapRegion(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            child: _formView(),
          ),
        ),
      ],
    );
  }

  Widget _formView() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            controller: _cEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
              labelText: "Email",
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.done,
            controller: _cPassword,
            keyboardType: TextInputType.text,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Password",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() {
                  _obscure = !_obscure;
                }),
              ),
            ),
          ),
          const SizedBox(height: 22),
          ButtonWidget(
            onTap: _onAuth,
            width: double.infinity,
            withShadow: false,
            child: const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ButtonWidget(
              onTap: () => _helper.jumpToPage(
                context,
                page: const RegisterPage(),
              ),
              withShadow: false,
              color: Colors.transparent,
              child: const Text(
                "Create Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ButtonWidget(
              onTap: () => _helper.jumpToPage(
                context,
                page: const ResetPasswordPage(),
              ),
              withShadow: false,
              color: Colors.transparent,
              child: const Text(
                "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
