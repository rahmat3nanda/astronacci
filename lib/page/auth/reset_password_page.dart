/*
 * *
 *  * reset_password_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 13:24
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 13:24
 *
 */

import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/button_widget.dart';
import 'package:astronacci/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late AuthBloc _bloc;
  late Helper _helper;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _cEmail;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    SingletonModel.withContext(context);
    _helper = Helper();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _formKey = GlobalKey();
    _cEmail = TextEditingController();
    _isLoading = false;
  }

  void _onReset() async {
    FocusScope.of(context).unfocus();
    String email = _cEmail.text.trim();

    if (email.isEmpty) {
      _helper.showToast("Email cannot be empty!");
      return;
    }

    if (!email.isValidEmail()) {
      _helper.showToast("Invalid email!");
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _bloc.add(AuthResetPasswordEvent(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) async {
        if (s is AuthResetPasswordSuccessState) {
          _isLoading = false;
          _cEmail.text = "";
          _helper.showToast(
            "Successfully sent password reset link.\nPlease check your email.",
          );
        } else if (s is AuthResetPasswordFailedState) {
          _isLoading = false;
          _helper.showToast(
            "Failed to send password reset link.\n${s.data.message}",
          );
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
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppIcon.astronacci,
                  width: 128,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: s.height * .175, width: double.infinity),
        Text(
          "Forgot Password",
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
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 22),
          ButtonWidget(
            onTap: _onReset,
            width: double.infinity,
            withShadow: false,
            child: const Text(
              "Reset",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
