import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:restaurants/bloc/bloc.dart';

import 'bloc/bloc.dart';
import 'helpers/database_helper.dart';
import 'models/restaurant.dart';
import 'screens.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const RestaurantsApp());
}

class RestaurantsApp extends StatelessWidget {
  const RestaurantsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseHelper>(
          create: (context) => DatabaseHelper.instance,
        ),
        Provider<AuthService>(
          create: (context) => AuthService(
            helper: Provider.of<DatabaseHelper>(
              context,
              listen: false,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurants App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          inputDecorationTheme: const InputDecorationTheme(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}

Route<dynamic>? _onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      builder: (context) {
        switch (settings.name) {
          case SplashScreen.routeName:
            return const SplashScreen();
          case SignupScreen.routeName:
            return const SignupScreen();
          case LoginScreen.routeName:
            return const LoginScreen();
          case RestaurantsScreen.routeName:
            return MyRestaurants(
              child: const RestaurantsScreen(),
            );
          case RestaurantScreen.routeName:
            return RestaurantScreen(
              restaurant: settings.arguments as Restaurant,
            );
          case SearchScreen.routeName:
            return MyProducts(
              child: const SearchScreen(),
            );
          case MapScreen.routeName:
            return MyMap(
              child: MapScreen(
                restaurants: settings.arguments as List<Restaurant>,
              ),
            );
        }
        return const SizedBox.shrink();
      },
    );
