import 'package:flutter/material.dart';
import 'package:productlist/src/features/product_list/data/model/product_model.dart';
import 'package:productlist/src/features/product_list/interactor/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final isFavorite = favoritesProvider.isFavorite(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.image,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Price: \$${product.price}'),
              const SizedBox(height: 8),
              Text(
                  'Rating: ${product.rating} (${product.ratingCount} reviews)'),
              const SizedBox(height: 8),
              Text('Category: ${product.category}'),
              const SizedBox(height: 8),
              Text('Description: ${product.description}'),
              const SizedBox(height: 16),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
