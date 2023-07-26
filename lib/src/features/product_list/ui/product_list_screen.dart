import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/model/product_model.dart';
import '../interactor/provider/favorites_provider.dart';
import '../interactor/provider/product_provider.dart';
import '../data/service/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    // Fetch products from the API on initialization
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();

    // Set up listener for the search field
    _searchController.addListener(_onSearchTextChanged);

    // Fetch products from the API on initialization
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();

    // Set up listener for the search field
    _searchController.addListener(_onSearchTextChanged);

    // Initialize the FavoritesProvider with the list of all products
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    favoritesProvider.favoriteProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final searchTerm = _searchController.text.toLowerCase();
    final allProducts =
        Provider.of<ProductProvider>(context, listen: false).products;

    setState(() {
      _displayedProducts = allProducts.where((product) {
        final title = product.title.toLowerCase();
        return title.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
              onPressed: () {
                // Navegar para a tela de adicionar produto
                Navigator.pushNamed(context, '/favorites');
              },
              icon: const Icon(Icons.favorite_border_rounded))
        ],
      ),
      body: Consumer2<ProductProvider, FavoritesProvider>(
        builder: (context, productProvider, favoritesProvider, _) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = _searchController.text.isNotEmpty
              ? _displayedProducts
              : productProvider.products;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchTextChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search Products',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchTextChanged();
                            },
                          )
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product, favoritesProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
      ProductModel product, FavoritesProvider favoritesProvider) {
    return GestureDetector(
      onTap: () {
        // Navigate to the product details screen
        // Implement this in a similar way as the product list screen
      },
      child: SizedBox(
        height: 50,
        child: Card(
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
