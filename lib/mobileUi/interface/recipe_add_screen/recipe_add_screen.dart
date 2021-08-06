import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/blocs/concrete/downloader/youtube_downloader_bloc.dart';

import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';
import 'package:flutter_meal_app_update/core/extensions/duration_extension.dart';
import 'package:flutter_meal_app_update/core/utilities/results/result.dart';
import 'package:flutter_meal_app_update/core/validation/recipe_validator.dart';
import 'package:flutter_meal_app_update/core/widgets/bottom_sheet_manager.dart';
import 'package:flutter_meal_app_update/core/widgets/snack_bar_manager.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_meal_app_update/models/concrete/utility.dart';

import 'package:image_picker/image_picker.dart';

class RecipeAddScreen extends StatefulWidget {
  @override
  _RecipeAddScreenState createState() => _RecipeAddScreenState();
}

class _RecipeAddScreenState extends State<RecipeAddScreen>
    with RecipeValidationMixin {
  Recipe recipe;
  final _formKey = GlobalKey<FormState>();
  var txtName = new TextEditingController();
  var txtIngredients = new TextEditingController();
  var txtLink = new TextEditingController();
  List<Category> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarif Ekle"),
      ),
      body: _recipeAddContent,
      floatingActionButton: _addActionButton,
    );
  }

  @override
  void initState() {
    super.initState();
    recipe = new Recipe.empty();
    loadCategories();
  }

  Widget get _recipeAddContent => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: _contentColumn,
      );

  Widget get _contentColumn => ListView(
        children: [_containerImageWidget, _sizedBox(5.0), _recipeForm],
      );

  Widget get _addActionButton => FloatingActionButton(
        tooltip: "Tarifi Kaydet",
        child: Icon(Icons.add),
        onPressed: saveRecipe,
      );

  ImageProvider<Object> get _imageAssetWidget {
    if (recipe.image64 == null) {
      return AssetImage(
        "assets/images/empty_food.jpg",
      );
    } else {
      return MemoryImage(
        Utility.dataFromBase64String(recipe.image64),
      );
    }
  }

  Widget get _containerImageWidget => Container(
        alignment:
            recipe.image64 == null ? Alignment.center : Alignment.topRight,
        width: double.infinity,
        height: context.calculateByPercentage(35, SideTypes.VERTICAL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          image: DecorationImage(
            image: _imageAssetWidget,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.darken),
          ),
        ),
        child: containerImageButtonList,
      );

  Widget get containerImageButtonList {
    return recipe.image64 == null
        ? _changePhotoButton
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [_changePhotoButton, _fullScreenImageButton],
          );
  }

  Widget get _changePhotoButton {
    bool isPhotoLoaded = recipe.image64 == null;
    return FloatingActionButton(
      tooltip: isPhotoLoaded ? "Resim Yükle" : "Resimi Değiştir",
      heroTag: "GetImage",
      child: Icon(
        isPhotoLoaded ? Icons.add_a_photo : Icons.refresh_sharp,
        size: context.calculateByPercentage(3, SideTypes.VERTICAL),
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onPressed: () {
        print("Clicked");
        showSheet(_bottomSheetContent);
      },
    );
  }

  Widget get _fullScreenImageButton => FloatingActionButton(
        child: Icon(
          Icons.fullscreen_sharp,
        ),
        tooltip: "Resmi Tam Ekran Yap",
        heroTag: "MakeFullScreen",
        onPressed: showZoomedPhotoDialog,
      );

  showSheet(List<Widget> widgets) {
    BottomSheetManager.showBottomSheet(context, children: widgets);
  }

  Widget _sizedBox(double percentage) => SizedBox(
      height: context.calculateByPercentage(percentage, SideTypes.VERTICAL));

  List<Widget> get _bottomSheetContent => [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _addFromGalleryButton,
            _addFromCameraButton,
          ],
        )
      ];

  Widget get _addFromGalleryButton => ElevatedButton.icon(
        label: Text("Galeriden Ekle"),
        icon: Icon(Icons.photo_album_rounded),
        onPressed: getPhotoFromGallery,
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
        ),
      );

  Widget get _addFromCameraButton => ElevatedButton.icon(
        label: Text("Kameradan Ekle"),
        icon: Icon(Icons.add_a_photo),
        onPressed: getPhotoFromCamera,
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          onPrimary: Theme.of(context).colorScheme.surface,
        ),
      );

  Future<void> getPhotoFromGallery() async {
    var photo = await ImagePicker().getImage(source: ImageSource.gallery);
    if (photo != null) {
      var photoFile = File(photo.path);
      setState(() {
        recipe.image64 = Utility.base64String(photoFile.readAsBytesSync());
      });
      photoFile.delete();
    }
    Navigator.pop(context);
  }

  Future<void> getPhotoFromCamera() async {
    var photo = await ImagePicker().getImage(source: ImageSource.camera);
    if (photo != null) {
      var photoFile = File(photo.path);
      setState(() {
        recipe.image64 = Utility.base64String(photoFile.readAsBytesSync());
      });
      photoFile.delete();
    }
    Navigator.pop(context);
  }

  void showZoomedPhotoDialog() {
    var photoDialog = AlertDialog(
      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.calculateByPercentage(2, SideTypes.HORIZONTAL),
          vertical: context.calculateByPercentage(2, SideTypes.VERTICAL),
        ),
        child: Image.memory(
          Utility.dataFromBase64String(recipe.image64),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
    showDialog(context: context, builder: (ctx) => photoDialog);
  }

  Widget get _recipeForm => Form(
        key: _formKey,
        child: Column(
          children: [
            _recipeNameField,
            _sizedBox(2),
            _recipeIngredientsField,
            _sizedBox(2),
            _recipeLinkField,
            _sizedBox(2),
            _recipeCategoryDropdownField
          ],
        ),
      );

  Widget get _recipeNameField => TextFormField(
        validator: validateName,
        onSaved: (value) {
          setState(() {
            recipe.recipeName = value;
          });
        },
        controller: txtName,
        decoration: InputDecoration(
            hintText: "Tarif Adını Giriniz", labelText: "Tarif Adı"),
      );

  Widget get _recipeIngredientsField => TextFormField(
        controller: txtIngredients,
        validator: validateIngredients,
        onSaved: (value) {
          setState(() {
            recipe.ingredients = value;
          });
        },
        decoration: InputDecoration(
            hintText: "Tarif Malzemelerini Girebilirsiniz",
            labelText: "Tarif Malzemeleri"),
      );

  Widget get _recipeLinkField => TextFormField(
        controller: txtLink,
        onSaved: (value) {
          setState(() {
            recipe.recipeLink = value;
          });
        },
        validator: validateYoutubeLink,
        decoration: InputDecoration(
          hintText: "Tarif Linkini Girebilirsiniz",
          labelText: "Tarif Linki",
          icon: txtLink.text.length <= 5
              ? null
              : FloatingActionButton(
                  heroTag: "GetImageOfVideo",
                  tooltip: "Girilen Youtube Linkinin Resmini Getir",
                  child: Icon(Icons.get_app),
                  onPressed: loadImageFromRecipeLink,
                ),
        ),
      );

  Widget get _recipeCategoryDropdownField {
    if (categories.length == 0) {
      return Text("Herhangi Bir Kategori Bulunmadı.");
    }
    return DropdownButton<int>(
      items: categories
          .map((category) => DropdownMenuItem(
                child: Text(category.name),
                value: category.id,
              ))
          .toList(),
      hint: Text("Tarifin Kategorisi"),
      value: recipe.categoryId,
      onChanged: (value) {
        setState(() {
          recipe.categoryId = value;
        });
      },
    );
  }

  void loadCategories() async {
    var result = await dbSqfliteCategoryBloc.getAll();
    setState(() {
      categories = result.data;
    });
  }

  void saveRecipe() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var imageValidation = validateImage(recipe.image64);
      if (imageValidation != null) {
        showValidationError(context, imageValidation);
        return;
      }
      var categoryValidation = validateCategory(recipe.categoryId);
      if (categoryValidation != null) {
        showValidationError(context, categoryValidation);
        return;
      }
      var result = await dbSqfliteRecipeBloc.add(recipe);
      showSuccessRecipeSaved(result);
    }
  }

  void showSuccessRecipeSaved(Result result) {
    SnackBarManager.showSuccessSnackBar(
      Text(result.message),
      context: context,
      duration: DurationLevel.HIGH,
    );
    Navigator.of(context).pop();
  }

  void loadImageFromRecipeLink() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    String image64 = await youtubeDownloaderBloc.getVideoImage64(txtLink.text);
    setState(() {
      recipe.image64 = image64;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
