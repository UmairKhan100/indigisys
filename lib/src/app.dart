// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/location_screen.dart';
import './screens/track_screen.dart';
import './screens/follow_screen.dart';
import './screens/analytics_screen.dart';
import './screens/notifications_screen.dart';
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
        builder: (context) {
          final bloc = LoginProvider.of(context);
          bloc.fetchCustomer();
          return LoginScreen();
        },
      );
    } else if (url.startsWith('/dashboard')) {
      final int customerId = int.parse(url.split('/')[2]);
      final String customerName = url.split('/')[3];
      final String token = url.split('/')[4];

      return MaterialPageRoute(
        builder: (context) => DashboardScreen(
            customerId: customerId, customerName: customerName, token: token),
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
    } else if (url.startsWith('/follow')) {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = AppProvider.of(context);
          final int customerId = int.parse(url.split('/')[2]);

          bloc.fetchVehicles(customerId);
          return FollowScreen();
        },
      );
    } else if (url.startsWith('/notifications')) {
      return MaterialPageRoute(
        builder: (context) {
          // final bloc = AppProvider.of(context);
          // final int customerId = int.parse(url.split('/')[2]);
          // bloc.fetchNotifications(customerId);

          return NotificationScreen();
        },
      );
    } else if (url.startsWith('/analytics')) {
      return MaterialPageRoute(
        builder: (context) {
          final int customerId = int.parse(url.split('/')[2]);
          final bloc = AppProvider.of(context);
          bloc.fetchStats(customerId);
          return AnalyticsScreen();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => Scaffold(),
      );
    }
  }
}
