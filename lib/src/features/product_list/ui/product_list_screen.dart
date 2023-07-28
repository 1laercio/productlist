import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../product_details/ui/product_details_screen.dart';
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
    // Schedule the fetchProducts() to run after the widgets are built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      });
    });

    // Set up listener for the search field
    _searchController.addListener(_onSearchTextChanged);

    // Fetch products from the API on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        final productProvider =
            Provider.of<ProductProvider>(context, listen: false);
        productProvider.fetchProducts();
      });
    });

    // Set up listener for the search field
    _searchController.addListener(_onSearchTextChanged);

    // Initialize the FavoritesProvider with the list of all products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        final favoritesProvider =
            Provider.of<FavoritesProvider>(context, listen: false);
        favoritesProvider.favoriteProducts;
      });
    });
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
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: Text(
          'Products',
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
              onPressed: () {
                // Navegar para a tela de adicionar produto
                Navigator.pushNamed(context, '/favorites');
              },
              iconSize: 24,
              color: const Color.fromRGBO(0, 0, 0, 1),
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(240, 241, 242, 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _onSearchTextChanged(),
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      border: InputBorder.none,
                      hintText: 'Search Anything',
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
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 1.9),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    if (index >= products.length || products.isEmpty) {
                      return Container(); // Ou outro widget de placeholder, caso a lista esteja vazia
                    }
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(product: product)));
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
                        child: CachedNetworkImage(
                          imageUrl: product.image,
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
