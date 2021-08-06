import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';

class CategoryAddScreen extends StatefulWidget {
  @override
  _CategoryAddScreenState createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  TextEditingController txtName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos_rounded),
        tooltip: "Kategori Ekle",
        onPressed: saveCategory,
      ),
      appBar: AppBar(
        title: Text("Kategori Ekleme Ekranı"),
      ),
      body: buildCategoryAddState(),
    );
  }

  Widget buildCategoryAddState() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          buildCategoryNameField(),
        ],
      ),
    );
  }

  Widget buildCategoryNameField() {
    return TextField(
      controller: txtName,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        decorationColor: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: "Kategori İsmi Giriniz.",
        icon: Icon(Icons.info),
        labelText: "Bir Kategori İsmi Giriniz.",
      ),
    );
  }

  saveCategory() async {
    String message;
    if (txtName.text.isEmpty || txtName.text == null) {
      message = "Kategori Adı Girilmedi.";
    } else {
      IResult addedresult =
          await dbSqfliteCategoryBloc.add(new Category(name: txtName.text));
      message = addedresult.message;
    }
    if (message != null) {
      var snackBar = new SnackBar(
        content: Text(
          message,
        ),
        action: SnackBarAction(
          label: "Tamam",
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
