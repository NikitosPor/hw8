@Timeout(Duration(seconds: 10))
@TestOn('vm')
import 'package:cocktail_app_tests/core/src/model/cocktail.dart';
import 'package:cocktail_app_tests/core/src/model/cocktail_category.dart';
import 'package:cocktail_app_tests/core/src/model/cocktail_type.dart';
import 'package:cocktail_app_tests/core/src/model/glass_type.dart';
import 'package:cocktail_app_tests/core/src/model/ingredient_definition.dart';
import '../lib/ui/pages/details/cocktail_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../package-simple/lib/src/continue_to_cover_test_classes/utilites/http_service.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

void main() {
  // HttpService httpServiceMock;
  // //FavoritesStorage favoritesStorage;
  const isNotFavorite = false;
  const isFavorite = true;

  final cocktailPositive = Cocktail(
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
  final cocktailNegative = Cocktail(
      id: "firstCoctail",
      name: "testCocktail",
      drinkThumbUrl:
          "https://www.thecocktaildb.com/images/media/drink/qvprvp1483388104.jpg",
      isFavourite: isNotFavorite,
      category: CocktailCategory.ordinaryDrink,
      cocktailType: CocktailType.alcoholic,
      glassType: GlassType.cocktailGlass,
      instruction: "Инструкции: бла-бла-бла",
      ingredients: [IngredientDefinition("Какава", "Размешать")]);

  group('CocktailDetailPage should', () {
    // late HttpService httpServiceMock;
    // setUp(() {
    //   httpServiceMock = HttpServiceMock();
    // });

    testWidgets('contain favorite icon button for cocktail from favorites',
        (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(_wrap(CocktailDetailPage(cocktailPositive)));

        final isFavoriteIconFinder = find.bySemanticsLabel("favorite");
        //final isFavoriteIconFinder = find.byIcon(Icons.favorite);
        expect(isFavoriteIconFinder, findsOneWidget);
      });
    });

    testWidgets('not contain favorite icon button if cocktail is not favorite',
        (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(_wrap(CocktailDetailPage(cocktailNegative)));

        final isFavoriteIconFinder = find.bySemanticsLabel("nonFavorite");
        //final isFavoriteIconFinder = find.byIcon(Icons.favorite_border);
        expect(isFavoriteIconFinder, findsOneWidget);
      });
    });
  });
}

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: child),
    );

