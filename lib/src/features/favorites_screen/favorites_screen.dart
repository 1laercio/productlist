import 'package:flutter/material.dart';
import 'package:productlist/src/features/product_list/data/model/product_model.dart';
import 'package:provider/provider.dart';

import '../product_list/interactor/provider/favorites_provider.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    if (favoritesProvider.favoriteProducts.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: favoritesProvider.favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoritesProvider.favoriteProducts[index];
          return _buildProductCard(product, favoritesProvider);
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, FavoritesProvider favoritesProvider) {
    return GestureDetector(
      onTap: () {
        // Implement navigation to product details screen
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$${product.price}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text('${product.rating} (${product.ratingCount})'),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: product.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(product);
                      product.toggleFavorite();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
