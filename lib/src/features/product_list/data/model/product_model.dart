import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  int id;
  String title;
  String image;
  double price;
  double rating;
  int ratingCount;
  String description;
  String category;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.category,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  // Add serialization methods (toJson, fromJson) if necessary
}
