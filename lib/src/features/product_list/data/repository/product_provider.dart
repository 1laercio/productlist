import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../service/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final products = await ApiService().fetchProducts();

      _products = products.map((data) {
        return Product(
          id: data['id'],
          title: data['title'],
          price: data['price'].toDouble(),
          rating: data['rating']['rate'].toDouble(),
          ratingCount: data['rating']['count'],
          description: data['description'],
          category: data['category'],
          image: data['image'],
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }
}