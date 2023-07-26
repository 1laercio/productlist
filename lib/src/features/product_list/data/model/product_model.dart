
class Product {
  final int id;
  final String title;
  final double price;
  final double rating;
  final int ratingCount;
  final String description;
  final String category;
  final String image;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.category,
    required this.image,
    this.isFavorite = false,
  });
}
