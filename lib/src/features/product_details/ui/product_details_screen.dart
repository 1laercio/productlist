import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productlist/src/features/product_list/data/model/product_model.dart';
import 'package:productlist/src/features/product_list/interactor/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final isFavorite = favoritesProvider.isFavorite(product);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(55, 71, 79, 1),
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color.fromRGBO(55, 71, 79, 1),
            ),
          ),
        ),
        actions: [
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    product.image,
                    width: 200,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(product.title,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6),
                  )),
              const SizedBox(height: 8),
              Row(children: [
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
                Text(
                  '\$${product.price}',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 29,
                        color: Color.fromRGBO(94, 196, 1, 1)),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.sort),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      product.category,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(62, 62, 62, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.menu),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        product.description,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromRGBO(62, 62, 62, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
