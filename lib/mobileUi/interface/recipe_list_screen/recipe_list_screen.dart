import 'package:flutter/material.dart';

import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_list_screen/navigation_drawer.dart';
import 'package:flutter_meal_app_update/mobileUi/interface/recipe_list_screen/recipe_item.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final selectedStyle = TextStyle(color: Colors.black);

  IDataResult result;

  bool showingMBanner = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: buildAppBar,
      body: buildStreamBuilderWidget,
      floatingActionButton: getAddButton,
    );
  }

  Widget get buildAppBar => AppBar(
        title: Text(
          "Tarifler",
        ),
        actions: [
          IconButton(
            color: Colors.transparent,
            onPressed: _goToSettingsScreen,
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );

  Widget get buildStreamBuilderWidget =>
      FutureBuilder<IDataResult<List<Recipe>>>(
        future: loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Tarifler Getiriliyor..."),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            if (snapshot.data.data.length == 0) {
              return Center(
                child: Text("Herhangi Bir Tarif Bulunamadı."),
              );
            }
            return buildColumn(snapshot);
          }
        },
      );

  Future<IDataResult<List<Recipe>>> loadRecipes() async {
    IDataResult<List<Recipe>> gotRecipes = await dbSqfliteRecipeBloc.getAll();
    result = gotRecipes;
    setState(() {});
    return gotRecipes;
  }

  buildColumn(AsyncSnapshot<IDataResult<List<Recipe>>> snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (result != null && showingMBanner) _buildResultBanner,
        Expanded(
          child: buildListView(snapshot),
        ),
      ],
    );
  }

  buildListView(AsyncSnapshot<IDataResult<List<Recipe>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        Recipe selectedRecipe = snapshot.data.data[index];
        return RecipeItem(
          recipe: selectedRecipe,
        );
      },
    );
  }

  get _buildResultBanner => MaterialBanner(
        content: Text(result.message),
        padding: EdgeInsets.symmetric(
          vertical: context.calculateByPercentage(
            2,
            SideTypes.VERTICAL,
          ),
          horizontal: context.calculateByPercentage(
            3,
            SideTypes.HORIZONTAL,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(
            result.isSuccess ? Icons.done : Icons.close,
          ),
        ),
        forceActionsBelow: true,
        actions: [
          TextButton(
            onPressed: _hideMBanner,
            child: Text(
              "Tamam",
            ),
          ),
        ],
        backgroundColor: result.isSuccess
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.error,
      );
  Widget get getAddButton => FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        tooltip: "Tarif Ekle",
        onPressed: () {
          Navigator.pushNamed(context, "/recipeAdd");
        },
      );

  void _goToSettingsScreen() {
    Navigator.of(context).pushNamed("/settings");
  }

  _hideMBanner() {
    setState(() {
      showingMBanner = !showingMBanner;
    });
  }
}
