import 'dart:async';
import 'dart:io';

import 'package:flutter_meal_app_update/models/concrete/category.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DbHelper {
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join((await createVideoDownloaderDir()).path, "youtube.db");
    var db;
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var db = await databaseFactory.openDatabase(dbPath,
          options: OpenDatabaseOptions(
            onCreate: createDb,
            version: 1,
          ));
      return db;
    } else {
      String dbPath = join(await getDatabasesPath(), "recipe.db");
      db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: createDb,
      );
      return db;
    }
  }

  FutureOr<void> createDb(Database db, int version) {
    createRecipeDb(db);
    createCategoryDb(db);
  }

  createVideoDownloaderDir() async {
    Directory mainDirectory;
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      mainDirectory = await path_provider.getDownloadsDirectory();
      Directory videoDownloaderDirectory =
          new Directory(mainDirectory.path + "/Yemek Tarifleri Uygulaması");
      if (videoDownloaderDirectory.existsSync() == false) {
        videoDownloaderDirectory =
            await videoDownloaderDirectory.create(recursive: true);
      }
      return videoDownloaderDirectory;
    } else {
      mainDirectory = await path_provider.getApplicationDocumentsDirectory();
      print("Main Directory: ${mainDirectory.path}");
      Directory videoDownloaderDirectory =
          new Directory(mainDirectory.path + "/Yemek Tarifleri Uygulaması");
      if (videoDownloaderDirectory.existsSync() == false) {
        videoDownloaderDirectory =
            await videoDownloaderDirectory.create(recursive: true);
      }
      return videoDownloaderDirectory;
    }
  }

  void createCategoryDb(Database db) {
    var sql =
        "Create Table categories(${Category.columnId[0]} ${Category.columnId[1]} primary key, ${Category.columnName[0]} ${Category.columnName[1]}, ${Category.columnParentId[0]} ${Category.columnParentId[1]}, ${Category.columnPath[0]} ${Category.columnPath[1]})";
    print("Sql $sql");
    db.execute(sql);
  }

  void createRecipeDb(Database db) {
    db.execute(
        "Create Table recipes(${Recipe.columnId[0]} ${Recipe.columnId[1]} primary key, ${Recipe.columnRecipeName[0]} ${Recipe.columnRecipeName[1]}, ${Recipe.columnRecipeLink[0]} ${Recipe.columnRecipeLink[1]}, ${Recipe.columnLocalVideoFilePath[0]} ${Recipe.columnLocalVideoFilePath[1]}, ${Recipe.columnLocalAudioFilePath[0]} ${Recipe.columnLocalAudioFilePath[1]}, ${Recipe.columnIngredients[0]} ${Recipe.columnIngredients[1]}, ${Recipe.columnImage64[0]} ${Recipe.columnImage64[1]}, ${Recipe.columnCategoryId[0]} ${Recipe.columnCategoryId[1]})");
  }
}
