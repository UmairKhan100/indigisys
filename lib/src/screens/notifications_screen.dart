// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

import '../resources/db_provider.dart';

class NotificationScreen extends StatelessWidget {
  final dbProvider = DbProvider();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: dbProvider.fetchNotifications(3),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List li = snapshot.data;

          if (li.isEmpty) {
            return Center(
              child: Text(
                'No Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: li.length,
              itemBuilder: (context, int index) {
                return buildTile(
                  context,
                  li[index],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildTile(BuildContext context, item) {
    return Column(
      children: [
        ListTile(
          title: Text(item['vehicleNumber']),
          subtitle: Text(item['alarmName']),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.timer_outlined),
              Text(item['gpsTime']),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
