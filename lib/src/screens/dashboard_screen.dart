// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../blocs/login_provider.dart';
import '../utils/fcm.dart';

class DashboardScreen extends StatelessWidget {
  final int customerId;
  final String customerName;
  final String token;
  final pushNotificationSystem = PushNotificationSystem();

  DashboardScreen(
      {required this.customerId,
      required this.customerName,
      required this.token});

  Widget build(BuildContext context) {
    pushNotificationSystem.whenNotificationReceived(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(customerName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          padding: EdgeInsets.all(12),
          shrinkWrap: true,
          children: [
            buildCard(
                index: 0, icon: Icons.map_outlined, text: 'Current Location'),
            buildCard(
                index: 1, icon: Icons.timeline_outlined, text: 'History Track'),
            buildCard(
                index: 2,
                icon: Icons.share_location_outlined,
                text: 'Follow Vehicle'),
            buildCard(
                index: 3, icon: Icons.assessment_outlined, text: 'Analytics'),
            buildCard(
                index: 4, icon: Icons.campaign_outlined, text: 'Notifications'),
            buildCard(index: 5, icon: Icons.logout_outlined, text: 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      {required int index, required IconData icon, required String text}) {
    return Builder(builder: ((context) {
      return GestureDetector(
        onTap: () async {
          if (index == 0) {
            Navigator.pushNamed(context, '/location/$customerId');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/track/$customerId');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/follow/$customerId');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/analytics/$customerId');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/notifications/$customerId');
          } else if (index == 5) {
            final bloc = LoginProvider.of(context);
            await bloc.clearCustomer(customerId, token);
            Navigator.pushNamedAndRemoveUntil(
                context, '/', (Route<dynamic> route) => false);
          }
        },
        child: Card(
          elevation: 2,
          color: index == 0 || index == 3 || index == 4
              ? Colors.deepPurpleAccent
              : Colors.indigoAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: Colors.white,
              ),
              Container(margin: const EdgeInsets.only(top: 10)),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      );
    }));
  }
}
