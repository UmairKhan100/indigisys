// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, depend_on_referenced_packages, must_be_immutable, prefer_const_constructors_in_immutables, no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../blocs/app_provider.dart';

late int vehicleId;

class TrackScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = AppProvider.of(context);
    final map = buildMap(bloc);
    final myTracks = buildMyTracks(bloc, context);

    return Scaffold(
      appBar: AppBar(
        title: Text('History Track'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          map,
          myTracks,
        ],
      ),
    );
  }

  Widget buildMap(AppBloc bloc) {
    return StreamBuilder(
      stream: bloc.vehicleTrack,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final parsedJson = snapshot.data;
        List packets = parsedJson['results'];

        List<LatLng> points = [];
        for (List packet in packets) {
          points.add(LatLng(double.parse(packet[5]), double.parse(packet[6])));
        }

        return points.isEmpty
            ? Center(
                child: Text(
                'Nothing to display',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.grey),
              ))
            : FlutterMap(
                options: MapOptions(
                  bounds: LatLngBounds.fromPoints(points),
                  boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(100)),
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
                          return Image.asset('images/letter-a.png');
                        },
                      ),
                      Marker(
                        point: points.first,
                        builder: (context) {
                          return Image.asset('images/letter-b.png');
                        },
                      )
                    ],
                  ),
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
                  Expanded(child: DropdownExample(vehicles: vehicles)),
                  SizedBox(width: 10),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(
                      'Select Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      final datePicker = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000, 01, 01, 0, 0),
                        lastDate: DateTime(2035, 12, 31, 23, 59),
                      );

                      if (datePicker != null) {
                        final String tableName =
                            'GPS_Packets_${datePicker.year}_${datePicker.month.toString().padLeft(2, "0")}_${datePicker.day.toString().padLeft(2, '0')}';
                        final String query =
                            'SELECT * FROM $tableName WHERE v_id=$vehicleId ORDER BY gps_time DESC';
                        bloc.fetchTrack(query);
                      }
                    },
                  ),
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
  DropdownExample({required this.vehicles});

  @override
  _DropdownExampleState createState() =>
      _DropdownExampleState(vehicles: vehicles);
}

class _DropdownExampleState extends State<DropdownExample> {
  String? dropdownValue;
  final Map vehicles;
  _DropdownExampleState({required this.vehicles});

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
        if (newValue != null) {
          vehicleId = int.parse(newValue);
        }

        setState(() {
          dropdownValue = newValue;
        });
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
