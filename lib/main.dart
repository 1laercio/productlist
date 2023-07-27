import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/features/favorites/ui/favorites_screen.dart';
import 'src/features/product_list/interactor/provider/favorites_provider.dart';
import 'src/features/product_list/interactor/provider/product_provider.dart';
import 'src/features/product_list/ui/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Handle loading state if needed
          return Container();
        }

        final sharedPreferences = snapshot.data!;

        return MultiProvider(
          providers: [
            Provider.value(value: sharedPreferences),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProxyProvider<SharedPreferences, FavoritesProvider>(
              create: (_) => FavoritesProvider(sharedPreferences),
              update: (_, prefs, favorites) =>
                  favorites!..updatePreferences(prefs),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Product App',
            theme: ThemeData(primarySwatch: Colors.blue),
            initialRoute: '/',
            routes: {
              '/': (context) => const ProductListScreen(),
              '/favorites': (context) => const FavoritesScreen(),
            },
          ),
        );
      },
    );
  }
}
