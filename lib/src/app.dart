// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indigisys App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('INDIGISYS'),
          centerTitle: true,
        ),
      ),
    );
  }
}
