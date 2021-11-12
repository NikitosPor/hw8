@Timeout(Duration(seconds: 10))
@TestOn('vm')
import 'package:cocktail_app_tests/core/src/model/cocktail_definition.dart';
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
  final asyncCocktailRepository = AsyncCocktailRepository();

  final cocktailFetchAnswer =
      '{"drinks":[{"idDrink": "11022", "strDrink": "Allies Cocktail", "strDrinkAlternate": null, "strDrinkES": null, "strDrinkDE": null, "strDrinkFR": null, "strDrinkZH-HANS": null, "strDrinkZH-HANT": null,"strTags": null,"strVideo": null,"strCategory": "Ordinary Drink","strIBA": null,"strAlcoholic": "Alcoholic","strGlass": "Cocktail glass","strInstructions": "Stir all ingredients with ice, strain contents into a cocktail glass, and serve.","strInstructionsES": null,"strInstructionsDE": "Alle Zutaten mit Eis verrühren, Inhalt in ein Cocktailglas abseihen und servieren.","strInstructionsFR": null,"strInstructionsZH-HANS": null,"strInstructionsZH-HANT": null,"strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/qvprvp1483388104.jpg","strIngredient1": "Dry Vermouth","strIngredient2": "Gin","strIngredient3": "Kummel","strIngredient4": null,"strIngredient5": null,"strIngredient6": null,"strIngredient7": null,"strIngredient8": null,"strIngredient9": null,"strIngredient10": null,"strIngredient11": null,"strIngredient12": null,"strIngredient13": null,"strIngredient14": null,"strIngredient15": null,"strMeasure1": "1 oz ","strMeasure2": "1 oz ","strMeasure3": "1/2 tsp ","strMeasure4": null,"strMeasure5": null,"strMeasure6": null,"strMeasure7": null,"strMeasure8": null,"strMeasure9": null,"strMeasure10": null,"strMeasure11": null,"strMeasure12": null,"strMeasure13": null,"strMeasure14": null,"strMeasure15": null,"strCreativeCommonsConfirmed": "No","dateModified": "2017-01-02 20:15:04"}]}';

  final fetchCocktailsByCocktailCategoryAnswer = '{"drinks": [{"strDrink": "1-900-FUK-MEUP","strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/uxywyw1468877224.jpg","idDrink": "15395"},{"strDrink": "24k nightmare","strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/yyrwty1468877498.jpg","idDrink": "17060"}]}';

  final fetchCocktailsByCocktailTypeAnswer = '{"drinks": [{"strDrink": "1-900-FUK-MEUP","strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/uxywyw1468877224.jpg","idDrink": "15395"},{"strDrink": "110 in the shade","strDrinkThumb": "https://www.thecocktaildb.com/images/media/drink/xxyywq1454511117.jpg","idDrink": "15423"}]}';

  group('FetchCocktailDetail should', () {
    test('returns an Cocktail if the http call completes successfully',
        () async {
      final client = MockClient();
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(
              Uri.parse(
                  'https://the-cocktail-db.p.rapidapi.com/lookup.php?i=11022'),
              headers: anyNamed("headers")))
          .thenAnswer((realInvocation) async =>
              http.Response(cocktailFetchAnswer, 200));

      expect(
          await asyncCocktailRepository.fetchCocktailDetails(client, "11022"),
          isA<Cocktail>());
    });

    test('throws an exception if the http call completes with an error',
        () async {
      final client = MockClient();
      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(
              Uri.parse(
                  'https://the-cocktail-db.p.rapidapi.com/lookup.php?i=11022'),
              headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(asyncCocktailRepository.fetchCocktailDetails(client, "11022"),
          throwsException);
    });
  });

  group('fetchCocktailsByCocktailCategory should', () {
    test('returns an Iterable<CocktailDefinition?> if the http call completes successfully',
            () async {
          final client = MockClient();
          // Use Mockito to return a successful response when it calls the
          // provided http.Client.
          when(client.get(
              Uri.parse(
                  'https://the-cocktail-db.p.rapidapi.com/filter.php?c=Shot'),
              headers: anyNamed("headers")))
              .thenAnswer((_) async =>
              http.Response(fetchCocktailsByCocktailCategoryAnswer, 200));

          expect(
              await asyncCocktailRepository.fetchCocktailsByCocktailCategory(client, CocktailCategory.shot),
              isA<Iterable<CocktailDefinition?>>());
        });
  });

  group('fetchCocktailsByCocktailType should', () {
    test('returns an Iterable<CocktailDefinition> if the http call completes successfully',
            () async {
          final client = MockClient();
          // Use Mockito to return a successful response when it calls the
          // provided http.Client.
          when(client.get(
              Uri.parse(
                  'https://the-cocktail-db.p.rapidapi.com/filter.php?a=Alcoholic'),
              headers: anyNamed("headers")))
              .thenAnswer((_) async =>
              http.Response(fetchCocktailsByCocktailTypeAnswer, 200));

          expect(
              await asyncCocktailRepository.fetchCocktailsByCocktailType(client, CocktailType.alcoholic),
              isA<Iterable<CocktailDefinition?>>());
        });
  });
}


// Widget _wrap(Widget child) => MaterialApp(
//       home: Scaffold(body: child),
//     );
