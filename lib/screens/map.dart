import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurants/bloc.dart';

import '../models/restaurant.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  final List<Restaurant> restaurants;
  const MapScreen({
    required this.restaurants,
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = Completer<GoogleMapController>();

  late final markers = widget.restaurants
      .map(
        (restaurant) => Marker(
          markerId: MarkerId('${restaurant.id!}'),
          position: LatLng(restaurant.latitude, restaurant.longitude),
          onTap: () async => await _showBottomSheet(context, restaurant),
        ),
      )
      .toSet();

  @override
  void initState() {
    super.initState();
    if (widget.restaurants.length == 1) {
      Future.delayed(
        Duration.zero,
        () => _showBottomSheet(context, widget.restaurants.first),
      );
    }
  }

  @override
  void dispose() {
    MyMap.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: StreamBuilder<Polyline>(
        stream: MyMap.of(context).polyline,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _fitPolyline(snapshot.data!);
          }
          return GoogleMap(
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            compassEnabled: false,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.restaurants[0].latitude,
                widget.restaurants[0].longitude,
              ),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
            polylines: snapshot.hasData ? {snapshot.data!} : {},
          );
        },
      ),
    );
  }

  Future<void> _fitPolyline(Polyline polyline) async {
    final controller = await _controller.future;
    double minLat = polyline.points.first.latitude;
    double minLong = polyline.points.first.longitude;
    double maxLat = polyline.points.first.latitude;
    double maxLong = polyline.points.first.longitude;

    final point = polyline.points[1];

    if (point.latitude < minLat) minLat = point.latitude;
    if (point.latitude > maxLat) maxLat = point.latitude;
    if (point.longitude < minLong) minLong = point.longitude;
    if (point.longitude > maxLong) maxLong = point.longitude;

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        0));
  }

  Future<void> _showBottomSheet(
      BuildContext context, Restaurant restaurant) async {
    await MyMap.of(context).getDistance(
      restaurant.latitude,
      restaurant.longitude,
    );
    await showModalBottomSheet(
      context: context,
      builder: (innerContext) {
        return SizedBox(
          child: ListTile(
            title: Text(restaurant.name),
            subtitle: StreamBuilder<double>(
              stream: MyMap.of(context).distance,
              builder: (context, snap) => (snap.hasData)
                  ? Text('${(snap.data! / 1000.0).toStringAsFixed(2)} km')
                  : const SizedBox.shrink(),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.route),
              onPressed: () async {
                await MyMap.of(context).getPolyline(
                  restaurant.latitude,
                  restaurant.longitude,
                );
                Navigator.pop(innerContext);
              },
            ),
          ),
        );
      },
    );
  }
}
