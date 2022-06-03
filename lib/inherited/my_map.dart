import 'package:flutter/material.dart';
import '../bloc/bloc.dart';

class MyMap extends InheritedWidget {
  final MapBloc bloc;
  MyMap({Key? key, Widget? child})
      : bloc = MapBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(oldWidget) => true;

  static MapBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyMap>() as MyMap).bloc;
  }
}
