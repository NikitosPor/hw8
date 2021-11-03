@Timeout(Duration(seconds: 10))
@TestOn('vm')
import 'package:http/http.dart' as http;
import 'package:cocktail_app_tests/core/src/model/cocktail.dart';
import 'package:cocktail_app_tests/core/src/model/cocktail_category.dart';
import 'package:cocktail_app_tests/core/src/model/cocktail_type.dart';
import 'package:cocktail_app_tests/core/src/model/glass_type.dart';
import 'package:cocktail_app_tests/core/src/model/ingredient_definition.dart';
import '../lib/ui/pages/details/cocktail_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../lib/core/src/repository/async_cocktail_repository.dart';
import '../../package-simple/lib/src/continue_to_cover_test_classes/utilites/http_service.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import 'asyncrepo_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // HttpService httpServiceMock;
  // //FavoritesStorage favoritesStorage;
  const isNotFavorite = false;
  const isFavorite = true;
  final asyncCocktailRepository = AsyncCocktailRepository();

  final cocktailTest = Cocktail(
      id: "firstCoctail",
      name: "testCocktail",
      drinkThumbUrl:
          "https://www.thecocktaildb.com/images/media/drink/qvprvp1483388104.jpg",
      isFavourite: isFavorite,
      category: CocktailCategory.ordinaryDrink,
      cocktailType: CocktailType.alcoholic,
      glassType: GlassType.cocktailGlass,
      instruction: "Инструкции: бла-бла-бла",
      ingredients: [IngredientDefinition("Какава", "Размешать")]);


  group('FetchCocktailDetail should', () {
    test('returns an Cocktail if the http call completes successfully', () async {
      final client = MockClient();
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
          .get(any))
          .thenAnswer((_) async =>
          http.Response(cocktailTest.toString(), 200));

      expect(await asyncCocktailRepository.fetchCocktailDetails(client, "23"),
          isA<Cocktail>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(asyncCocktailRepository.fetchCocktailDetails(client, "23"),
          throwsException);
    });
  });
}

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: child),
    );

