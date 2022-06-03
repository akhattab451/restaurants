import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurants/bloc/bloc.dart';

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
  @override
  void dispose() {
    MyMap.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = widget.restaurants
        .map(
          (restaurant) => Marker(
            markerId: MarkerId('${restaurant.id!}'),
            position: LatLng(restaurant.latitude, restaurant.longitude),
            onTap: () async {
              await MyMap.of(context).getDistance(
                restaurant.latitude,
                restaurant.longitude,
              );
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200.0,
                    child: ListTile(
                      title: Text(restaurant.name),
                      subtitle: StreamBuilder<double>(
                        stream: MyMap.of(context).distance,
                        builder: (context, snap) => (snap.hasData)
                            ? Text('${(snap.data! / 1000.0)} km')
                            : const SizedBox.shrink(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.route),
                        onPressed: () async {
                          MyMap.of(context).getPolyline(
                            restaurant.latitude,
                            restaurant.longitude,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
        .toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: StreamBuilder<Polyline>(
        stream: MyMap.of(context).polyline,
        builder: (context, snapshot) {
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
            markers: markers,
            polylines: snapshot.hasData ? {snapshot.data!} : {},
          );
        },
      ),
    );
  }
}
