import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_file/open_file.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  IDataResult dataResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dataResult == null
            ? "Kategoriler Listeleniyor..."
            : dataResult.message),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 25),
        child: buildListViewFutureBuilder(),
      ),
    );
  }

  Widget buildListViewFutureBuilder() {
    return FutureBuilder<IDataResult<List<Category>>>(
      future: loadCategories(),
      initialData: dataResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Kategoriler Listeleniyor..."),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          if (snapshot.data.data.length == 0) {
            return Center(
              child: Text("Herhangi Bir Kategori Bulunamadı."),
            );
          }
          return buildCategoryListViewItems(snapshot, context);
        }
      },
    );
  }

  Future<IDataResult<List<Category>>> loadCategories() async {
    IDataResult<List<Category>> categoriesResult =
        await dbSqfliteCategoryBloc.getAll();
    for (Category category in categoriesResult.data) {
      category.hasVideoCount =
          (await dbSqfliteRecipeBloc.getAllByCategoryId(category.id))
              .data
              .length;
      category.hasDownloadedVideoCount =
          (await dbSqfliteRecipeBloc.getAllByCategoryId(category.id))
              .data
              .where((video) => video.isVideoDownloaded == true)
              .length;
      category.hasDownloadedAudioCount =
          (await dbSqfliteRecipeBloc.getAllByCategoryId(category.id))
              .data
              .where((video) => video.isAudioDownloaded == true)
              .length;
    }
    setState(() {
      dataResult = categoriesResult;
    });
    return categoriesResult;
  }

  ListView buildCategoryListViewItems(
      AsyncSnapshot<IDataResult<List<Category>>> snapshot, context) {
    return ListView.builder(
      itemCount: snapshot.data.data.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              caption: "Seçili Katgoriyi Sil",
              onTap: () {
                dbSqfliteCategoryBloc
                    .delete(snapshot.data.data[index])
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    duration: Duration(seconds: 5),
                    content: Text(value.message),
                  ));
                });
              },
            ),
          ],
          child: Card(
            color: Colors.deepPurple,
            child: buildCategoryTile(snapshot.data.data[index], context),
          ),
        );
      },
    );
  }

  buildCategoryTile(Category category, context) {
    return ExpansionTile(
      leading: CircleAvatar(
        child: Text(
          category.id.toString(),
        ),
      ),
      title: Text(category.name),
      subtitle: Text(category.path),
      children: [
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.name),
          subtitle: Text("Kategori Adı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.path),
          subtitle: Text("Kategori Klasörünün Konumu"),
          trailing: IconButton(
            icon: Icon(Icons.copy_rounded),
            tooltip: "Klasörün Konumunu Kopyala",
            onPressed: () {
              FlutterClipboard.controlC(category.path).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  new SnackBar(
                    backgroundColor: Colors.black,
                    duration: Duration(seconds: 9),
                    content: Text("Konum Kopyalandı.",
                        style: TextStyle(color: Colors.white)),
                    action: SnackBarAction(
                      label: "Klasörü Aç",
                      textColor: Colors.white,
                      onPressed: () async {
                        await OpenFile.open(category.path);
                      },
                    ),
                  ),
                );
              });
            },
          ),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.parentId == null
              ? "Yok"
              : "${category.parentId} Nolu Kategori"),
          subtitle: Text("Kategorinin Üst Kategorisi"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.hasVideoCount.toString()),
          subtitle: Text("Kategoriye Kaydedilmiş Video Sayısı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.hasDownloadedVideoCount.toString()),
          subtitle: Text("Kategoriye Ait İndirilmiş Video Dosyası Sayısı"),
        ),
        ListTile(
          tileColor: Colors.blueGrey,
          title: Text(category.hasDownloadedAudioCount.toString()),
          subtitle: Text("Kategoriye Ait İndirilmiş Sadece Ses Dosyası Sayısı"),
        ),
      ],
    );
  }
}
