import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application/models/cources_meta_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CourcesMetaDataModel> _products;
  int _currentIndex = 0;
  bool _isLoading = false;
  bool searchBar = false;
  late List<CourcesMetaDataModel> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products?limit=3&start=$_currentIndex'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<CourcesMetaDataModel> products = responseData
          .map((json) => CourcesMetaDataModel.fromJson(json))
          .toList();

      setState(() {
        _products.addAll(products);
        _filteredProducts.addAll(products);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _loadMoreProducts() {
    setState(() {
      _currentIndex += 3;
    });
    _fetchProducts();
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      floatingActionButton: Container(
        child: Card(
          color: Colors.blue,
          child: CupertinoButton(
            onPressed: _loadMoreProducts,
            child: const Text(
              'Load More',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('academy'),
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
        centerTitle: true,
      ),
      body: Column(
        children: [
          searchBar == true
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      if (value.length >= 3) {
                        _filterProducts(value);
                      } else {
                        setState(() {
                          _filteredProducts = List.from(_products);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _filteredProducts.length) {
                  final product = _filteredProducts[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Image.network(
                                            product.image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: size.width * 0.6,
                                          child: Text(product.title),
                                        ),
                                        Text(
                                          '\u0024${product.price.toString()}',
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
