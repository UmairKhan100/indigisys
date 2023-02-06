// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './blocs/login_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return LoginProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: routes,
        title: 'Indigisys App',
      ),
    );
  }

  Route routes(settings) {
    final String url = settings.name.toString();

    if (url == '/') {
      return MaterialPageRoute(builder: (context) => LoginScreen());
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(),
    );
  }
}
