import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_detail_screen/children/no_update_child_screen.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({this.recipe});

  final appBartabs = [
    Tab(
      text: "Düzenleme Kapalı",
    ),
    Tab(
      text: "Düzenleme Açık",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: _detailBody);
  }

  get _appBar => AppBar(
        title: Text("Tarif Detay Ekranı"),
        bottom: TabBar(
          tabs: appBartabs,
        ),
      );
  get _detailBody => Scaffold(
        appBar: _appBar,
        body: TabBarView(
          children: [
            NoUpdateChildScreen(
              recipe: recipe,
            ),
            Column(),
          ],
        ),
      );
}
