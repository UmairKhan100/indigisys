// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, depend_on_referenced_packages, no_logic_in_create_state, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../resources/api_provider.dart';
import '../blocs/app_provider.dart';

dynamic timer2;
List<LatLng> points = [];
List gpsTime = [];

late int vehicleId;
final apiProvider = ApiProvider();

test(bloc, packet, tableName, date, time) async {
  final response = await apiProvider.fetchTrack(
    'SELECT * FROM $tableName WHERE v_id=$vehicleId and gps_time > TIMESTAMP("$date", "$time") ORDER BY gps_time',
  );

  final List newPackets = response['results'];
  if (newPackets.isNotEmpty) {
    gpsTime = newPackets.last[3].split('T');
  }

  for (List packet in newPackets) {
    points.add(LatLng(double.parse(packet[5]), double.parse(packet[6])));
  }

  bloc.followVehicle(0);
}

class FollowScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = AppProvider.of(context);
    final map = buildMap(bloc);
    final myTracks = buildMyTracks(bloc, context);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Follow Vehicle'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            map,
            myTracks,
          ],
        ),
      ),
      onWillPop: () async {
        if (timer2 != null) {
          points = [];
          gpsTime = [];
          timer2.cancel();
        }
        return true;
      },
    );
  }

  Widget buildMap(AppBloc bloc) {
    return StreamBuilder(
      stream: bloc.follow,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final parsedJson = snapshot.data;
        final packet = parsedJson['result'];

        if (packet != null && packet.isNotEmpty) {
          points.add(LatLng(double.parse(packet[5]), double.parse(packet[6])));
          points.add(LatLng(double.parse(packet[5]), double.parse(packet[6])));
          gpsTime = packet[3].split('T');

          Timer.periodic(
            Duration(seconds: 10),
            (timer) {
              timer2 = timer;
              String date = gpsTime[0];
              String time = gpsTime[1].split('.')[0];
              final String tableName =
                  'gps_packets_${date.replaceAll("-", "_")}';

              test(bloc, packet, tableName, date, time);
            },
          );
        }

        return points.isEmpty
            ? Container()
            : FlutterMap(
                options: MapOptions(
                  center: points.last,
                  bounds: LatLngBounds.fromPoints(points),
                  boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(140)),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: points, strokeWidth: 5, color: Colors.blue)
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: points.last,
                        builder: (context) {
                          return Image.asset('images/car.png');
                        },
                      ),
                    ],
                  )
                ],
              );
      },
    );
  }

  Widget buildMyTracks(AppBloc bloc, context) {
    return StreamBuilder(
      stream: bloc.vehicles,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final parsedJson = snapshot.data;

        if (parsedJson['success'] == 'yes') {
          final Map vehicles = parsedJson['data'];

          return Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Select Vehicle',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: DropdownExample(
                    vehicles: vehicles,
                    bloc: bloc,
                  )),
                  SizedBox(width: 10),
                ],
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class DropdownExample extends StatefulWidget {
  final Map vehicles;
  final AppBloc bloc;
  DropdownExample({required this.vehicles, required this.bloc});

  @override
  _DropdownExampleState createState() =>
      _DropdownExampleState(vehicles: vehicles, bloc: bloc);
}

class _DropdownExampleState extends State<DropdownExample> {
  String? dropdownValue;
  final Map vehicles;
  final AppBloc bloc;
  _DropdownExampleState({required this.vehicles, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue;
        });
        if (newValue != null) {
          vehicleId = int.parse(newValue);
          bloc.followVehicle(int.parse(newValue));
        }
      },
      items: vehicles.entries.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item.key.toString(),
          child: Text(item.value),
        );
      }).toList(),
    );
  }
}
