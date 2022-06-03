import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapBloc {
  final _polyline = BehaviorSubject<Polyline>();
  Stream<Polyline> get polyline => _polyline.stream;
  StreamSink<Polyline> get _polylineSink => _polyline.sink;

  final _distance = BehaviorSubject<double>();
  Stream<double> get distance => _distance.stream;
  StreamSink<double> get _distanceSink => _distance.sink;

  void dispose() {
    _polyline.close();
    _distance.close();
  }

  Future<void> getDistance(double latitude, double longitude) async {
    await _checkPermissions();

    final currentPosition = await Geolocator.getCurrentPosition();
    final distanceBetween = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      latitude,
      longitude,
    );

    _distanceSink.add(distanceBetween);
  }

  Future<void> getPolyline(double latitude, double longitude) async {
    await _checkPermissions();

    final currentPosition = await Geolocator.getCurrentPosition();
    final route = Polyline(
      polylineId: const PolylineId('polyline1'),
      color: Colors.blueGrey,
      width: 5,
      points: [
        LatLng(latitude, longitude),
        LatLng(currentPosition.latitude, currentPosition.longitude)
      ],
    );

    _polylineSink.add(route);
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
  }
}
