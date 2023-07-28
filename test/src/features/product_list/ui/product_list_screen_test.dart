import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:productlist/src/features/product_list/data/model/product_model.dart';
import 'package:productlist/src/features/product_list/interactor/provider/favorites_provider.dart';
import 'package:productlist/src/features/product_list/ui/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o pacote necessário

void main() {
  test('Teste de adicionar e remover favoritos', () async {
    // Obtenha uma instância válida de SharedPreferences antes de criar o FavoritesProvider
    final sharedPreferences = await SharedPreferences.getInstance();
    final favoritesProvider = FavoritesProvider(sharedPreferences);

    // Verifique se a lista de favoritos está inicialmente vazia
    expect(favoritesProvider.favoriteProducts, isEmpty);

    // Adicione um produto aos favoritos e verifique se está na lista de favoritos
    final product1 = ProductModel(
      id: 1,
      title: 'Produto 1',
      category: '',
      image: '',
      rating: 3,
      description: '',
      ratingCount: 2,
      price: 20,
    );
    favoritesProvider.toggleFavorite(product1);
    expect(favoritesProvider.favoriteProducts, contains(product1));

    // Remova o mesmo produto dos favoritos e verifique se ele foi removido da lista de favoritos
    favoritesProvider.toggleFavorite(product1);
    expect(favoritesProvider.favoriteProducts, isNot(contains(product1)));
  });
}

void widget() {
  testWidgets('Teste de renderização do ProductListScreen',
      (WidgetTester tester) async {
    // Crie um widget de teste para ProductListScreen
    await tester.pumpWidget(const MaterialApp(home: ProductListScreen()));

    // Verifique se o título da AppBar está correto
    expect(find.text('Products'), findsOneWidget);

    // Verifique se o campo de pesquisa está presente na tela
    expect(find.byType(TextField), findsOneWidget);

    // Simule uma digitação no campo de pesquisa
    await tester.enterText(find.byType(TextField), 'Produto 1');

    // Verifique se o texto digitado foi inserido corretamente no campo de pesquisa
    expect(find.text('Produto 1'), findsOneWidget);

    // Teste outros aspectos da tela conforme necessário
  });
}
