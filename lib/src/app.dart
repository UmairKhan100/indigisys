// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/location_screen.dart';
import './screens/track_screen.dart';
import './blocs/login_provider.dart';
import './blocs/app_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return LoginProvider(
      child: AppProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes,
          title: 'Indigisys App',
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    final String url = settings.name.toString();

    if (url == '/') {
      return MaterialPageRoute(
        builder: (context) => LoginScreen(),
        // DashboardScreen(
        //   customerId: 3,
        //   customerName: 'Usman Shahid',
        // )
      );
    } else if (url.startsWith('/dashboard')) {
      final int customerId = int.parse(url.split('/')[2]);
      final String customerName = url.split('/')[3];

      return MaterialPageRoute(
        builder: (context) =>
            DashboardScreen(customerId: customerId, customerName: customerName),
      );
    } else if (url.startsWith('/location')) {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = AppProvider.of(context);
          final int customerId = int.parse(url.split('/')[2]);

          bloc.fetchVehiclesLastPackets(customerId);
          return LocationScreen();
        },
      );
    } else if (url.startsWith('/track')) {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = AppProvider.of(context);
          final int customerId = int.parse(url.split('/')[2]);

          bloc.fetchVehicles(customerId);
          return TrackScreen();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => Scaffold(),
      );
    }
  }
}
