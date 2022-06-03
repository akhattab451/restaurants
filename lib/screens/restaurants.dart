import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants/widgets/restaurant_card.dart';

import '../inherited/my_restaurants.dart';
import '../models/restaurant.dart';
import '../services/auth_service.dart';
import '../screens.dart';

class RestaurantsScreen extends StatefulWidget {
  static const routeName = '/restaurants';
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => MyRestaurants.of(context).getRestaurants(),
    );
  }

  @override
  void dispose() {
    MyRestaurants.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                Provider.of<AuthService>(context, listen: false).signOut();
                Navigator.pushReplacementNamed(
                  context,
                  LoginScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Restaurant>>(
        stream: MyRestaurants.of(context).restaurants,
        builder: (context, snapshot) {
          return IconButton(
            onPressed: () {
              if (snapshot.hasData) {
                Navigator.pushNamed(context, MapScreen.routeName,
                    arguments: snapshot.data);
              }
            },
            icon: Icon(Icons.map),
          );
          // if (!snapshot.hasData) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // final restaurants = snapshot.data!;
          // return GridView.builder(
          //   shrinkWrap: true,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 1.0,
          //     mainAxisSpacing: 8.0,
          //     crossAxisSpacing: 8.0,
          //   ),
          //   padding: const EdgeInsets.all(8.0),
          //   itemCount: restaurants.length,
          //   itemBuilder: (context, index) {
          //     return RestaurantCard(restaurant: restaurants[index]);
          //   },
          // );
        },
      ),
    );
  }
}
