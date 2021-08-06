import 'dart:async';

import 'package:flutter_meal_app_update/blocs/abstract/i_recipe_bloc.dart';
import 'package:flutter_meal_app_update/core/utilities/helpers/file_helper.dart';
import 'package:flutter_meal_app_update/data/concrete/sqflite/db_recipe_service.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';

class DbSqfliteRecipeBloc implements IRecipeBloc {
  FileHelper _fileHelper;

  DbSqfliteRecipeBloc() {
    this._fileHelper = new FileHelper();
  }

  @override
  Future<IResult> add(Recipe entity) async {
    IResult result = await DbRecipeService.add(entity);
    return result;
  }

  @override
  Future<IResult> delete(Recipe entity) async {
    IResult result = await DbRecipeService.delete(entity);
    if (entity.isVideoDownloaded && result.isSuccess) {
      var result2 = _fileHelper.deleteFile(entity.localVideoFilePath);
      print("Silindi Mi ? : ${result2}");
    }
    return result;
  }

  @override
  Future<IDataResult<List<Recipe>>> getAll() async {
    IDataResult<List<Recipe>> result = await DbRecipeService.getAll();
    return result;
  }

  @override
  Future<IDataResult<List<Recipe>>> getAllByCategoryId(int categoryId) async {
    IDataResult result = await DbRecipeService.getAllByCategoryId(categoryId);
    return result;
  }

  @override
  Future<IDataResult<Recipe>> getById(int id) async {
    IDataResult result = await DbRecipeService.getById(id);
    return result;
  }

  @override
  Future<IResult> update(Recipe entity) async {
    IResult result = await DbRecipeService.update(entity);
    return result;
  }
}

final dbSqfliteRecipeBloc = new DbSqfliteRecipeBloc();
