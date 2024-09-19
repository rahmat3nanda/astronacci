/*
 * *
 *  * register_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/19/2024, 03:28
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/19/2024, 03:28
 *
 */

import 'package:intl/intl.dart';
import 'package:astronacci/bloc/auth/auth_bloc.dart';
import 'package:astronacci/common/constants.dart';
import 'package:astronacci/common/styles.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/tool/always_disabled_focus_node.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:astronacci/widget/button_widget.dart';
import 'package:astronacci/widget/loading_overlay.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthBloc _bloc;
  late Helper _helper;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _cEmail;
  late TextEditingController _cPassword;
  late TextEditingController _cPasswordConfirm;
  late TextEditingController _cFullName;
  String? _religion;
  UserGenderModel? _gender;
  late TextEditingController _cBirthPlace;
  late TextEditingController _cBirthDate;
  DateTime? _birthDate;
  late bool _obscure;
  late bool _obscureConfirm;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    SingletonModel.withContext(context);
    _helper = Helper();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _formKey = GlobalKey();
    _cEmail = TextEditingController();
    _cPassword = TextEditingController();
    _cPasswordConfirm = TextEditingController();
    _cFullName = TextEditingController();
    _cBirthPlace = TextEditingController();
    _cBirthDate = TextEditingController();
    _setupForm();
    _isLoading = false;
  }

  void _setupForm() {
    _cEmail.text = "";
    _cPassword.text = "";
    _cPasswordConfirm.text = "";
    _cFullName.text = "";
    _religion = null;
    _gender = null;
    _cBirthPlace.text = "";
    _cBirthDate.text = "";
    _birthDate = null;
    _obscure = true;
    _obscureConfirm = true;
  }

  void _onPickDate({
    required DateTime? initial,
    required Function(DateTime) onPicked,
  }) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (newSelectedDate != null) {
      onPicked(newSelectedDate);
    }
  }

  void _onAuth() async {
    FocusScope.of(context).unfocus();
    String email = _cEmail.text.trim();
    String password = _cPassword.text.trim();
    String passwordConfirm = _cPasswordConfirm.text.trim();
    String fullName = _cFullName.text.trim();
    String birthPlace = _cBirthPlace.text.trim();

    if (email.isEmpty) {
      _helper.showToast("Email cannot be empty!");
      return;
    }
    if (!email.isValidEmail()) {
      _helper.showToast("Invalid email!");
      return;
    }

    if (password.isEmpty) {
      _helper.showToast("Password cannot be empty!");
      return;
    }

    if (passwordConfirm.isEmpty) {
      _helper.showToast("Retype Password cannot be empty!");
      return;
    }

    if (password != passwordConfirm) {
      _helper.showToast("Password does not match!");
      return;
    }

    if (fullName.isEmpty) {
      _helper.showToast("Full Name cannot be empty!");
      return;
    }

    if (_religion?.isEmpty ?? true) {
      _helper.showToast("Religion cannot be empty!");
      return;
    }

    if (_gender == null) {
      _helper.showToast("Gender cannot be empty!");
      return;
    }

    if (birthPlace.isEmpty) {
      _helper.showToast("Birth Place cannot be empty!");
      return;
    }

    if (_birthDate == null) {
      _helper.showToast("Birth Date cannot be empty!");
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;
      _bloc.add(AuthRegisterEvent(
        email: email,
        password: password,
        fullName: fullName,
        religion: _religion!,
        gender: _gender!,
        birthPlace: birthPlace,
        birthDate: _birthDate!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) async {
        if (s is AuthRegisterSuccessState) {
          _isLoading = false;
          _helper.showToast("Success Sign up. Please check your inbox");
        } else if (s is AuthRegisterFailedState) {
          _isLoading = false;
          _helper.showToast("Failure Sign up.\n${s.data.message}");
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
        const SizedBox(height: 32, width: double.infinity),
        Text(
          "Sign up",
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
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            controller: _cPassword,
            keyboardType: TextInputType.text,
            obscureText: _obscure,
            decoration: InputDecoration(
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
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            controller: _cPasswordConfirm,
            keyboardType: TextInputType.text,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              hintText: "Retype Password",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() {
                  _obscureConfirm = !_obscureConfirm;
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            controller: _cFullName,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: "Full Name"),
          ),
          const SizedBox(height: 12),
          DropdownSearch<String>(
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "Religion",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
              ),
            ),
            selectedItem: _religion,
            items: const [
              "Islam",
              "Christian",
              "Catholic",
              "Hindu",
              "Buddhist",
              "Confucian",
              "Others"
            ],
            itemAsString: (r) => r,
            onChanged: (r) => setState(() {
              _religion = r;
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text("Gender:"),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(UserGenderModel.male.name.toUpperCase()),
                  leading: Radio<UserGenderModel>(
                    value: UserGenderModel.male,
                    groupValue: _gender,
                    onChanged: (v) => setState(() {
                      _gender = v;
                    }),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(UserGenderModel.female.name.toUpperCase()),
                  leading: Radio<UserGenderModel>(
                    value: UserGenderModel.female,
                    groupValue: _gender,
                    onChanged: (v) => setState(() {
                      _gender = v;
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            controller: _cBirthPlace,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Birth Place"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            focusNode: AlwaysDisabledFocusNode(),
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            controller: _cBirthDate,
            keyboardType: TextInputType.text,
            onTap: () => _onPickDate(
              initial: _birthDate,
              onPicked: (d) => setState(() {
                _birthDate = d;
                _cBirthDate.text = DateFormat("yyyy-MM-dd").format(d);
              }),
            ),
            decoration: const InputDecoration(hintText: "Birth Date"),
          ),
          const SizedBox(height: 22),
          ButtonWidget(
            onTap: _onAuth,
            width: double.infinity,
            withShadow: false,
            child: const Text(
              "Register",
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
