import 'package:flutter/material.dart';
import '../bloc/bloc.dart';
import '../models/product.dart';
import '../models/restaurant.dart';
import 'map.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    MyProducts.of(context).dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            MyProducts.of(context).getProducts(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: MyProducts.of(context).products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(snapshot.data![index].name),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MapScreen.routeName,
                        arguments: snapshot.data![index].restaurants
                            as List<Restaurant>,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
