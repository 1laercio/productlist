import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productlist/src/features/product_list/data/model/product_model.dart';
import 'package:provider/provider.dart';

import '../../product_list/interactor/provider/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    if (favoritesProvider.favoriteProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment
              .center, // Centralizar os elementos verticalmente
          children: [
            Image.network(
              'https://www.figma.com/file/mNgC26HuTYGaiRvpPVZFkR/test?type=design&node-id=2-1339&mode=design&t=kU486v2sJz45EKhm-4',
              width: 200,

              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'The list is empty',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(55, 71, 79, 1),
        title: Text(
          'Favorites',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color.fromRGBO(55, 71, 79, 1),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.9,
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

  Widget _buildProductCard(
      ProductModel product, FavoritesProvider favoritesProvider) {
    return GestureDetector(
      onTap: () {
        // Implement navigation to product details screen
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ]),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 5,
                  left: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 8, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(product.title,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${product.rating} (${product.ratingCount} reviews)',
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Color(0x37474FA6),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '\$${product.price}',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Color(0xAAF37A20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
