// ignore_for_file: annotate_overrides, avoid_renaming_method_parameters

import 'package:flutter/material.dart';

import './app_bloc.dart';
export './app_bloc.dart';

class AppProvider extends InheritedWidget {
  final bloc = AppBloc();

  AppProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AppBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>()!.bloc;
  }
}
