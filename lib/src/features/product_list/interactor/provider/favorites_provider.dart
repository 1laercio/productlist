import 'package:flutter/material.dart';
import '../../data/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProductModel> _favoriteProducts = [];
  SharedPreferences _prefs;

  FavoritesProvider(this._prefs);

  List<ProductModel> get favoriteProducts => _favoriteProducts;

  void _loadFavorites() {
    final favoriteIds = _prefs.getStringList('favorites') ?? [];

    _favoriteProducts.clear();
    for (final id in favoriteIds) {
      final product = _favoriteProducts.firstWhere(
        (product) => product.id.toString() == id,
      );
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }

   bool isFavorite(ProductModel product) {
    return _favoriteProducts.contains(product);
  }

  void updatePreferences(SharedPreferences prefs) {
    _prefs = prefs;
    _loadFavorites();
  }

  void toggleFavorite(ProductModel product) {
    final index = _favoriteProducts.indexWhere((fav) => fav.id == product.id);
    if (index >= 0) {
      _favoriteProducts.removeAt(index);
    } else {
      _favoriteProducts.add(product);
    }
    _saveFavorites();
    notifyListeners();
  }

  void _saveFavorites() {
    final favoriteIds =
        _favoriteProducts.map((product) => product.id.toString()).toList();
    _prefs.setStringList('favorites', favoriteIds);
  }
}
