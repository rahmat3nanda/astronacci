/*
 * *
 *  * profile_edit_page.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/21/2024, 00:30
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/21/2024, 00:30
 *
 */

import 'package:astronacci/common/styles.dart';
import 'package:astronacci/widget/button_widget.dart';
import 'package:astronacci/widget/image_network_widget.dart';
import 'package:astronacci/widget/loading_overlay.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:astronacci/bloc/profile/profile_bloc.dart';
import 'package:astronacci/model/app/singleton_model.dart';
import 'package:astronacci/model/user_model.dart';
import 'package:astronacci/tool/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late SingletonModel _model;
  late ProfileBloc _bloc;
  late Helper _helper;

  late GlobalKey<FormState> _formKey;
  late TextEditingController _cEmail;
  late TextEditingController _cFullName;
  late UserReligionModel _religion;
  late UserGenderModel _gender;
  late TextEditingController _cBirthPlace;
  late TextEditingController _cBirthDate;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _model = SingletonModel.withContext(context);
    _bloc = BlocProvider.of<ProfileBloc>(context);
    _helper = Helper();
    _formKey = GlobalKey();
    _cEmail = TextEditingController();
    _cFullName = TextEditingController();
    _cBirthPlace = TextEditingController();
    _cBirthDate = TextEditingController();
    _isLoading = false;
    _setupData();
  }

  void _setupData() {
    UserModel user = _model.user!;
    _cEmail.text = user.email ?? "-";
    _cFullName.text = user.fullName ?? "-";
    _cBirthPlace.text = user.birthPlace ?? "-";
    _cBirthDate.text =
        DateFormat("yyyy-MM-dd").format(user.birthDate ?? DateTime.now());
    _religion = user.religion ?? UserReligionModel.others;
    _gender = user.gender ?? UserGenderModel.male;
  }

  void _onSave() {
    FocusScope.of(context).unfocus();

    String fullName = _cFullName.text.trim();
    String birthPlace = _cBirthPlace.text.trim();

    if (fullName.isEmpty) {
      _helper.showToast("Full Name cannot be empty!");
      return;
    }

    if (birthPlace.isEmpty) {
      _helper.showToast("Birth Place cannot be empty!");
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _isLoading = true;

      UserModel user = _model.user!;
      user.fullName = fullName;
      user.religion = _religion;
      user.gender = _gender;
      user.birthPlace = birthPlace;

      _bloc.add(ProfileEditEvent(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (c, s) {
        if (s is ProfileEditSuccessState) {
          _isLoading = false;
          _model = SingletonModel.withContext(context);
          _setupData();
        } else if (s is ProfileEditFailedState) {
          _isLoading = false;
          _helper.showToast("Failure update data");
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
              appBar: AppBar(
                title: const Text("Edit Profile"),
              ),
              body: SafeArea(child: _mainView()),
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
            clickable: false,
            url: _model.user?.imageUrl ?? "",
          ),
        ),
        const SizedBox(height: 32),
        TapRegion(
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          child: _formView(),
        ),
      ],
    );
  }

  Widget _formView() {
    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        physics: const NeverScrollableScrollPhysics(),
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
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            controller: _cFullName,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Full Name",
              hintText: "Full Name",
            ),
          ),
          const SizedBox(height: 12),
          DropdownSearch<UserReligionModel>(
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Religion",
                hintText: "Religion",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
              ),
            ),
            selectedItem: _religion,
            items: UserReligionModel.values,
            itemAsString: (r) => r.name,
            onChanged: (r) => setState(() {
              _religion = r!;
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
                      _gender = v!;
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
                      _gender = v!;
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
            decoration: const InputDecoration(
              labelText: "Birth Place",
              hintText: "Birth Place",
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            controller: _cBirthDate,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Birth Date",
              hintText: "Birth Date",
            ),
          ),
          const SizedBox(height: 22),
          ButtonWidget(
            onTap: _onSave,
            width: double.infinity,
            withShadow: false,
            child: const Text(
              "Save",
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
