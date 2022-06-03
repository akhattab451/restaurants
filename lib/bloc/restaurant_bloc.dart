import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models.dart';

class RestaurantBloc {
  final _restaurants = BehaviorSubject<List<Restaurant>>();

  Stream<List<Restaurant>> get restaurants => _restaurants.stream;
  StreamSink<List<Restaurant>> get _restaurantsSink => _restaurants.sink;

  void dispose() {
    _restaurants.close();
  }

  Future<void> getRestaurants() async {
    final url = Uri.parse('http://192.168.1.27:80/listRestu');
    final response = await http.get(url);
    final jsonResponse = jsonDecode(response.body);

    final restaurants = (jsonResponse as List<dynamic>)
        .map((restaurant) => Restaurant.fromJson(restaurant))
        .toList();

    _restaurantsSink.add(restaurants);
  }
}
