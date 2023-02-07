// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/dashboard_screen.dart';
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
      return MaterialPageRoute(
        builder: (context) => DashboardScreen(customerId: 3),
      );
    } else if (url.startsWith('/dashboard/')) {
      final int customerId = int.parse(url.split('/dashboard/')[1]);

      return MaterialPageRoute(
        builder: (context) => DashboardScreen(customerId: customerId),
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => Scaffold(),
      );
    }
  }
}
