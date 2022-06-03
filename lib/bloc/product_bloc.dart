import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProductBloc {
  final _products = BehaviorSubject<List<Product>>();
  Stream<List<Product>> get products => _products.stream;
  StreamSink<List<Product>> get _productSink => _products.sink;

  void dispose() {
    _products.close();
  }

  Future<void> getProducts(String keyword) async {
    final url = Uri.parse('http://192.168.1.27:80/listprodcut/$keyword');
    final response = await http.get(url);
    final jsonResponse = jsonDecode(response.body);

    final products = (jsonResponse as List<dynamic>)
        .map((product) => Product.fromJson(product))
        .toList();

    _productSink.add(products);
  }
}
