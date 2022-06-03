import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../screens.dart';

class RestaurantScreen extends StatelessWidget {
  static const routeName = '/restaurant';
  final Restaurant restaurant;
  const RestaurantScreen({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.route),
            onPressed: () {
              Navigator.pushNamed(
                context,
                MapScreen.routeName,
                arguments: [restaurant],
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: restaurant.image!,
            fit: BoxFit.cover,
            placeholder: (c, _) => const CircularProgressIndicator(),
          ),
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Products',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            separatorBuilder: (c, i) => const Divider(),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: restaurant.products.length,
            itemBuilder: (c, i) {
              return Text(restaurant.products[i]);
            },
          ),
        ],
      ),
    );
  }
}
