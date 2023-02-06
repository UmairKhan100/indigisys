// ignore_for_file: annotate_overrides, avoid_renaming_method_parameters, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import './login_bloc.dart';
export './login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginProvider>()!.bloc;
  }
}
