import 'dart:io';

import 'package:flutter_meal_app_update/core/constants/messages.dart';
import 'package:flutter_meal_app_update/core/utilities/results/error_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/error_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/success_data_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/success_result.dart';
import 'package:flutter_meal_app_update/data/abstract/i_category_service.dart';
import 'package:flutter_meal_app_update/data/concrete/sqflite/db_helper.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';

class DbCategoryService extends ICategoryService {
  static DbHelper _dbHelper = new DbHelper();
  static DbCategoryService _singleton = new DbCategoryService._internal();

  factory DbCategoryService() {
    return _singleton;
  }

  DbCategoryService._internal();

  static Future<IResult> add(Category entity) async {
    try {
      entity.path = (await _createCategoryDir(entity));
      var result = await (await _dbHelper.db)
          .insert("categories", entity.convertToMap());
      return result > 0
          ? new SuccessResult.withMessage(Messages.categoryAddedSucceed)
          : new ErrorResult.withMessage(Messages.categoryAddedUnsucceed);
    } catch (error) {
      return new ErrorResult.withMessage(
          "Bir Hata Oluştu: ${error.toString()}");
    }
  }

  static Future<IResult> delete(Category entity) async {
    try {
      var result = await (await _dbHelper.db)
          .rawDelete("delete from categories where id=${entity.id}");
      if (entity.path.runtimeType == String && entity.path != null) {
        File(entity.path).delete(recursive: true);
      }
      return result > 0
          ? new SuccessResult.withMessage(Messages.categoryDeletedSucceed)
          : new ErrorResult.withMessage(Messages.categoryDeletedUnsucceed);
    } catch (error) {
      return new ErrorResult.withMessage(
          "Bir Hata Oluştu: ${error.toString()}");
    }
  }

  static Future<IDataResult<List<Category>>> getAll() async {
    try {
      var result = await (await _dbHelper.db).query("categories");
      List<Category> categories = List.generate(result.length, (index) {
        return Category.fromData(result[index]);
      });
      return new SuccessDataResult<List<Category>>(
          Messages.categoryListedSucceed, categories);
    } catch (error) {
      return new ErrorDataResult.onlyMessage(
          "Bir Hata Oluştu: ${error.toString()}");
    }
  }

  static Future<IDataResult<Category>> getById(int id) async {
    try {
      var result = Category.fromData(
          (await (await _dbHelper.db).query("categories"))
              .firstWhere((element) => element["id"] == id));
      return new SuccessDataResult<Category>(
          Messages.categoryUpdatedSucceed, result);
    } catch (error) {
      return new ErrorDataResult.onlyMessage(
          "Bir Hata Oluştu: ${error.toString()}");
    }
  }

  static Future<IResult> update(Category entity) async {
    try {
      List<Category> test = (await getAll()).data;
      test.forEach((element) async {
        if (element.id == entity.id) {
          if (entity.name != entity.name) {
            print("İfe Girildi");
            entity = await _changeDirectory(element, entity);
          }
        }
      });
      var result = await (await _dbHelper.db).update(
          "categories", entity.convertToMap(),
          where: "id=?", whereArgs: [entity.id]);
      return result > 0
          ? new SuccessResult.withMessage(Messages.categoryUpdatedSucceed)
          : new ErrorResult.withMessage(Messages.categoryUpdatedUnsucceed);
    } catch (error) {
      return new ErrorResult.withMessage(
          "Bir Hata Oluştu: ${error.toString()}");
    }
  }

  static Future<String> _createCategoryDir(Category category) async {
    String mainPath = (await _dbHelper.createVideoDownloaderDir()).path;
    Directory mainDirPath = Directory("$mainPath/Kategoriler Ve Dosyalar");
    if (mainDirPath.existsSync() == false) {
      mainDirPath = await mainDirPath.create(recursive: true);
    }
    String mainCategoryPath = category.parentId == null
        ? mainDirPath.path
        : (await getCategoryById(category.parentId)).data.path;
    Directory dir = Directory("$mainCategoryPath/${category.name}");
    if (dir.existsSync()) {
      dir.delete();
    }
    dir = await dir.create(recursive: true);
    return dir.path;
  }

  static Future<IDataResult<Category>> getCategoryById(int id) async {
    try {
      return new SuccessDataResult<Category>(
        "Kategori Getirme İşlemi Başarılı",
        new Category.fromData(
          (await (await _dbHelper.db).query("categories"))
              .firstWhere((element) => element["id"] == id),
        ),
      );
    } catch (error) {
      return new ErrorDataResult.onlyMessage(
          "Kategori Getirme İşlemi Başarısız");
    }
  }

  static Future<Category> _changeDirectory(
      Category element, Category category) async {
    Directory dir = Directory(element.path);
    Directory newDir = await dir.rename(
        '${(await _dbHelper.createVideoDownloaderDir()).path}/Kategoriler Ve Dosyalar/${category.name}');
    category.path = newDir.path;
    return category;
  }
}
