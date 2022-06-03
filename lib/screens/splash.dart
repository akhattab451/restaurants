import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../inherited/my_restaurants.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../screens.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: Provider.of<AuthService>(context, listen: false).user,
        builder: (context, snap) {
          if (snap.data == null) {
            return const LoginScreen();
          }
          return MyRestaurants(child: const RestaurantsScreen());
        },
      ),
    );
  }
}
