import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/extensions/duration_extension.dart';
import 'package:flutter_meal_app_update/core/widgets/bottom_sheet_manager.dart';
import 'package:flutter_meal_app_update/core/widgets/snack_bar_manager.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_meal_app_update/models/concrete/utility.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';
import 'package:open_file/open_file.dart';

class RecipeItem extends StatefulWidget {
  final Recipe recipe;

  const RecipeItem({Key key, this.recipe}) : super(key: key);

  @override
  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  @override
  Widget build(BuildContext context) {
    return _getItemContainer;
  }

  Container get _getItemContainer => Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(
              context.calculateByPercentage(
                7.5,
                SideTypes.HORIZONTAL,
              ),
            )),
        width: double.infinity,
        child: _getItemRow,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );

  Row get _getItemRow => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getItemImageContainer,
          _getDetailContainer,
        ],
      );

  Container get _getItemImageContainer => Container(
        height: context.calculateByPercentage(
          14,
          SideTypes.VERTICAL,
        ),
        width: context.calculateByPercentage(
          32,
          SideTypes.HORIZONTAL,
        ),
        child: _getItemImage,
      );

  Image get _getItemImage => Image.memory(
        Utility.dataFromBase64String(widget.recipe.image64),
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );

  Container get _getDetailContainer => Container(
        width: context.calculateByPercentage(58, SideTypes.HORIZONTAL),
        child: Column(
          children: [
            _getRecipeItemNameChip,
            SizedBox(
              height: context.calculateByPercentage(1.2, SideTypes.VERTICAL),
            ),
            _getItemButtons,
          ],
        ),
      );

  TextStyle get _getBoldTextStyle => TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.surface,
      );
  ButtonBar get _getItemButtons => ButtonBar(
        mainAxisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.center,
        buttonHeight: context.calculateByPercentage(
          40,
          SideTypes.HORIZONTAL,
        ),
        children: [
          _getItemDeleteButton,
          _getItemOptionsButton,
        ],
      );
  ElevatedButton get _getItemOptionsButton => ElevatedButton(
        onPressed: () => _showSheet(_detailsBottomSheetContent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Seçenekler"),
            SizedBox(
              width: context.calculateByPercentage(
                2,
                SideTypes.HORIZONTAL,
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );

  ElevatedButton get _getItemDeleteButton => ElevatedButton(
        onPressed: () => deleteRecipe(widget.recipe),
        child: Text("Sil"),
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

  RawChip get _getRecipeItemNameChip => RawChip(
        label: Text(
          widget.recipe.recipeName.length > 25
              ? widget.recipe.recipeName.substring(0, 22) + "..."
              : widget.recipe.recipeName,
          style: _getBoldTextStyle,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      );

  List<Widget> get _detailsBottomSheetContent => <Widget>[
        _goToVideoScreenButton(),
        _goToAudioScreenButton(),
        _goToRecipeDetailButton(),
        _openOnYoutubeVideoButton(),
      ];

  Widget _goToVideoScreenButton() => ElevatedButton.icon(
        label: Text(
          widget.recipe.isVideoDownloaded ? "Videoyu İzle" : "Videoyu İndir",
        ),
        icon: Icon(widget.recipe.selectedVideoDownloadedIcon),
        onPressed: () => _goToVideoScreen(widget.recipe),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
          minimumSize: _buttonSize,
        ),
      );

  Widget _goToAudioScreenButton() => ElevatedButton.icon(
        label: Text(
          widget.recipe.isAudioDownloaded ? "Sesi Dinle" : "Sesi İndir",
        ),
        icon: Icon(widget.recipe.selectedAudioDownloadedIcon),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
          minimumSize: _buttonSize,
        ),
      );

  Widget _goToRecipeDetailButton() => ElevatedButton(
        child: Text(
          "Detaya Git",
        ),
        onPressed: () => goToDetail(widget.recipe),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
          minimumSize: _buttonSize,
        ),
      );

  Widget _openOnYoutubeVideoButton() => ElevatedButton.icon(
        label: Text("Youtube Üzerinden İzle"),
        icon: Icon(Icons.play_circle_fill_rounded),
        onPressed: () => goToYoutubeVideoScreen(widget.recipe),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
          minimumSize: _buttonSize,
        ),
      );

  Size get _buttonSize => Size(
        context.calculateByPercentage(100, SideTypes.HORIZONTAL) - 20,
        context.calculateByPercentage(4, SideTypes.VERTICAL),
      );

  void _showSheet(List<Widget> widgets) => BottomSheetManager.showBottomSheet(
        context,
        children: widgets,
        percentage: 30,
      );

  void _goToVideoScreen(Recipe currentRecipe) {
    Navigator.pop(context);
    if (currentRecipe.isVideoDownloaded) {
      OpenFile.open(currentRecipe.localVideoFilePath);
    } else {
      Navigator.of(context).pushNamed(
        "/downloadVideo",
        arguments: currentRecipe,
      );
    }
  }

  void deleteRecipe(Recipe recipe) async {
    var result = await dbSqfliteRecipeBloc.delete(recipe);
    if (result.isSuccess) {
      SnackBarManager.showSuccessSnackBar(
        Text(result.message),
        context: context,
        duration: DurationLevel.HIGH,
      );
    } else {
      SnackBarManager.showErrorSnackBar(
        Text(result.message),
        context: context,
      );
    }
  }

  void goToDetail(Recipe currentRecipe) {
    Navigator.of(context).pushNamed(
      "/recipeDetail",
      arguments: currentRecipe,
    );
  }

  void goToYoutubeVideoScreen(Recipe recipe) {
    Navigator.of(context).pushNamed("/playOnYoutube", arguments: recipe);
  }
}
