import 'package:flutter/material.dart';
import '../bloc.dart';

class MyProducts extends InheritedWidget {
  final ProductBloc bloc;
  MyProducts({Key? key, Widget? child})
      : bloc = ProductBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(oldWidget) => true;

  static ProductBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyProducts>()
            as MyProducts)
        .bloc;
  }
}
