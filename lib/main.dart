import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/features/product_list/data/repository/product_provider.dart';
import 'src/features/product_list/ui/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ProductListScreen(),
      ),
    );
  }
}
