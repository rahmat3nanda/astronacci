/*
 * *
 *  * theme.dart - astronacci
 *  * Created by Rahmat Trinanda (rahmat3nanda@gmail.com) on 09/18/2024, 18:39
 *  * Copyright (c) 2024 . All rights reserved.
 *  * Last modified 09/18/2024, 18:29
 *
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astronacci/common/styles/app_color.dart';

class AppTheme {
  static ThemeData main(BuildContext context) => ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: AppColor.primary,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColor.primary,
          ),
        ),
        cardTheme: const CardTheme(surfaceTintColor: Colors.transparent),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: AppColor.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        primaryColor: AppColor.primaryLight,
        primaryColorDark: AppColor.primary,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColor.secondary,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          hintStyle: const TextStyle(fontWeight: FontWeight.w500),
          labelStyle: TextStyle(color: AppColor.primary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(width: 1, color: AppColor.secondary),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(width: 1, color: Colors.transparent),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.secondary,
        ),
      );
}
