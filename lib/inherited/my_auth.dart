import 'package:flutter/material.dart';
import '../bloc.dart';

class MyAuth extends InheritedWidget {
  final AuthBloc bloc;
  MyAuth({Key? key, Widget? child})
      : bloc = AuthBloc(),
        super(key: key, child: child!);
  @override
  bool updateShouldNotify(oldWidget) => true;

  static AuthBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<MyAuth>() as MyAuth)
        .bloc;
  }
}
