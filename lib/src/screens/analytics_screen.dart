// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../blocs/app_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = AppProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: bloc.stats,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data['success'] == 'no') {
            return Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data['data'];

          return SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              children: [
                StaggeredGridTile.fit(
                  crossAxisCellCount: 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: buildCard(
                      index: 0, text: 'Not Responding\n\n (${stats["nr"]}) '),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: buildCard(
                      index: 1, text: 'Moving\n\n (${stats["moving"]}) '),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: buildCard(
                      index: 2, text: 'Stopped\n\n (${stats["stopped"]}) '),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child:
                      buildCard(index: 3, text: 'Idle\n\n (${stats["idle"]}) '),
                ),
                StaggeredGridTile.fit(
                  crossAxisCellCount: 2,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      'Alarms Report',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCard({required int index, required String text}) {
    final Color? color;

    if (index == 0) {
      color = Colors.red;
    } else if (index == 1) {
      color = Colors.green;
    } else if (index == 2) {
      color = Colors.blue;
    } else {
      color = Colors.orange;
    }

    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            color: color,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
