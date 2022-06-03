import 'package:flutter/material.dart';

import '../bloc.dart';

class MyRestaurants extends InheritedWidget {
  final RestaurantBloc bloc;
  MyRestaurants({Key? key, Widget? child})
      : bloc = RestaurantBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(oldWidget) => true;

  static RestaurantBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyRestaurants>()
            as MyRestaurants)
        .bloc;
  }
}
