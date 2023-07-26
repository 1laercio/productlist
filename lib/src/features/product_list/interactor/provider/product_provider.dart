import 'package:flutter/material.dart';

import '../../data/model/product_model.dart';
import '../../data/service/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final products = await ApiService().fetchProducts();

      _products = products.map((data) {
        return ProductModel(
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