// ignore_for_file: use_key_in_widget_constructors, annotate_overrides, prefer_const_constructors, prefer_const_constructors_in_immutables, sort_child_properties_last, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../blocs/app_provider.dart';

class LocationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = AppProvider.of(context);

    return StreamBuilder(
      stream: bloc.vehiclesLastPackets,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Current Location'),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<Marker> markers = [];
        List<LatLng> points = [];

        final parsedJson = snapshot.data;
        if (parsedJson['success'] == 'yes') {
          final packets = parsedJson['data'];

          for (var element in packets) {
            LatLng point = LatLng(element[3], element[4]);
            points.add(point);
            markers.add(
              Marker(
                height: 80,
                width: 40,
                point: point,
                builder: (context) {
                  return PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: Image.asset('images/car.png'),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            child: Text('Vehicle Number: ${element[0]}')),
                        PopupMenuItem(child: Text('GPS Time: ${element[1]}')),
                        PopupMenuItem(child: Text('Speed: ${element[2]}')),
                        PopupMenuItem(child: Text('Latitude: ${element[3]}')),
                        PopupMenuItem(child: Text('Longitude: ${element[4]}')),
                        PopupMenuItem(child: Text('Address: ${element[5]}')),
                      ];
                    },
                  );
                },
              ),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Current Location'),
            centerTitle: true,
          ),
          body: FlutterMap(
            options: MapOptions(
              bounds: LatLngBounds.fromPoints(points),
              boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(50)),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 120,
                  size: Size(40, 40),
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markers,
                  builder: (context, markers) {
                    return FloatingActionButton(
                      child: Text(markers.length.toString()),
                      onPressed: null,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
