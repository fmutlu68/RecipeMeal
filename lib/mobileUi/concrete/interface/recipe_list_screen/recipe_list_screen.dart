import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/mobileUi/concrete/interface/components/recipe_list_screen_components/navigation_drawer.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final selectedStyle = TextStyle(color: Colors.black);
  IDataResult result;
  String _appBarContent = "Tarifler Getiriliyor...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(_appBarContent),
      ),
      body: buildStreamListView(),
      floatingActionButton: getAddButton(),
    );
  }

  buildStreamListView() {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: buildStreamBuilderWidget(),
    );
  }

  buildStreamBuilderWidget() {
    return FutureBuilder<IDataResult<List<Recipe>>>(
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
          return buildListView(snapshot);
        }
      },
    );
  }

  Future<IDataResult<List<Recipe>>> loadRecipes() async {
    IDataResult<List<Recipe>> gotRecipes = await dbSqfliteRecipeBloc.getAll();
    result = gotRecipes;
    _appBarContent = gotRecipes.message;
    setState(() {});
    return gotRecipes;
  }

  buildListView(AsyncSnapshot<IDataResult<List<Recipe>>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        Recipe selectedRecipe = snapshot.data.data[index];
        return Slidable(
          child: buildCard(selectedRecipe),
          actionPane: SlidableScrollActionPane(),
          secondaryActions: [
            IconSlideAction(
              onTap: () async {
                // await goToSelectedYoutubeVideoScreen(
                //     selectedRecipe.isVideoDownloaded,
                //     selectedRecipe.isAudioDownloaded,
                //     selectedRecipe,
                //     DownloaderState.Audio);
              },
              color: Colors.blue,
              icon: selectedRecipe.selectedAudioDownloadedIcon,
              foregroundColor: Colors.black,
              iconWidget: Text(
                  selectedRecipe.isAudioDownloaded
                      ? "Sesini Dinle"
                      : "Sesini İndir",
                  style: TextStyle(color: Colors.black)),
            ),
            IconSlideAction(
              onTap: () async {
                // await goToSelectedYoutubeVideoScreen(
                //     list[index].isVideoDownloaded,
                //     list[index].isAudioDownloaded,
                //     list[index],
                //     DownloaderState.Video);
              },
              color: Colors.blue,
              icon: selectedRecipe.selectedVideoDownloadedIcon,
              foregroundColor: Colors.black,
              iconWidget: Text(
                  selectedRecipe.isVideoDownloaded
                      ? "Videoyu İzle"
                      : "Videoyu İndir",
                  style: TextStyle(color: Colors.black)),
            )
          ],
          actions: [
            IconSlideAction(
              caption: "Sil",
              icon: Icons.delete_forever_rounded,
              color: Colors.red,
              foregroundColor: Colors.black,
              onTap: () async {
                IResult result =
                    await dbSqfliteRecipeBloc.delete(selectedRecipe);
                ScaffoldMessenger.of(context).showSnackBar(
                  new SnackBar(
                    content: Text(result.message),
                    duration: Duration(
                      seconds: 5,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Card buildCard(Recipe selectedRecipe) {
    return Card(
      color: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            selectedRecipe.id.toString(),
          ),
        ),
        title: Text(
          selectedRecipe.recipeName,
          style: selectedStyle,
        ),
        subtitle: Text(
          "Video Dosyası İndirildi Mi: ${selectedRecipe.isVideoDownloaded ? "Evet" : "Hayır"}\nSes Dosyası İndirildi Mi: ${selectedRecipe.isAudioDownloaded ? "Evet" : "Hayır"}",
          style: selectedStyle,
        ),
        trailing: Text(
          "Kategori Numarası: ${selectedRecipe.categoryId}",
          style: selectedStyle,
        ),
      ),
    );
  }

  getAddButton() {
    return FloatingActionButton(
      child: Icon(Icons.add_box_rounded),
      tooltip: "Tarif Ekle",
      onPressed: () {
        Navigator.pushNamed(context, "/recipeAdd");
      },
    );
  }
}
