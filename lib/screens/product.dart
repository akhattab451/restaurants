import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../screens.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';
  final Product product;
  const ProductScreen({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: ListView(
        children: [
          // CachedNetworkImage(
          //   imageUrl: restaurant.image!,
          //   fit: BoxFit.cover,
          //   placeholder: (c, _) => const CircularProgressIndicator(),
          // ),
          // const SizedBox(height: 16.0),
          ListTile(
            title: const Text(
              'Restaurants',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.route),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MapScreen.routeName,
                  arguments: product.restaurants,
                );
              },
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            separatorBuilder: (c, i) => const Divider(),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.restaurants.length,
            itemBuilder: (c, i) {
              return Text(product.restaurants[i].name);
            },
          ),
        ],
      ),
    );
  }
}
