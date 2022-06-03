import 'package:flutter/material.dart';
import '../bloc.dart';
import '../models/restaurant.dart';
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
      drawer: MyAuth(
        child: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  await MyAuth.of(context).signOut();
                  Navigator.pushReplacementNamed(
                    context,
                    LoginScreen.routeName,
                  );
                },
              ),
            ],
          ),
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
            icon: const Icon(Icons.map),
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
          //     final restaurant = restaurants[index];
          //     return InkWell(
          //       onTap: () => Navigator.pushNamed(
          //         context,
          //         RestaurantScreen.routeName,
          //         arguments: restaurant,
          //       ),
          //       child: Material(
          //         elevation: 3.0,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Expanded(
          //               child: CachedNetworkImage(
          //                 imageUrl: restaurant.image!,
          //                 placeholder: (c, u) => const Center(
          //                   child: CircularProgressIndicator(),
          //                 ),
          //                 errorWidget: (c, _, __) => const Padding(
          //                   padding: EdgeInsets.all(10.0),
          //                   child: Icon(
          //                     Icons.image_not_supported,
          //                     size: 50,
          //                     color: Colors.grey,
          //                   ),
          //                 ),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(vertical: 4.0),
          //               child: Text(
          //                 restaurant.name,
          //                 maxLines: 1,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: const TextStyle(
          //                   fontSize: 16.0,
          //                   fontWeight: FontWeight.w600,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
