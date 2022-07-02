import 'dart:io';

import 'package:cinema/app_cubit.dart';
import 'package:cinema/models.dart';
import 'package:flutter/material.dart';
import 'package:cinema/theme.dart';
import 'package:cinema/view/home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return BlocProvider(
      create: (_) => AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          LocalJsonLocalization.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        home: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Scaffold(
            backgroundColor: CinemaTheme.backgroundColor,
            body: const Home(),
          ),
        ),
      ),
    );
  }
}
