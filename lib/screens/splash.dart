import 'package:flutter/material.dart';
import '../bloc.dart';
import '../screens.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => MyAuth.of(context).checkLogin(),
    );
  }

  @override
  void dispose() {
    MyAuth.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: MyAuth.of(context).loggedIn,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.data == false) {
            return const LoginScreen();
          }
          return MyRestaurants(child: const RestaurantsScreen());
        },
      ),
    );
  }
}
