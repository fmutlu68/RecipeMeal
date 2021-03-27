import 'dart:async';

import 'package:flutter_meal_app_update/blocs/abstract/i_category_bloc.dart';
import 'package:flutter_meal_app_update/data/concrete/sqflite/db_category_service.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_result.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';

class DbSqfliteCategoryBloc implements ICategoryBloc {
  final _categoryStreamController = StreamController.broadcast();
  Stream get getStream => _categoryStreamController.stream;
  @override
  Future<IResult> add(Category entity) async {
    IResult result = await DbCategoryService.add(entity);
    if (result.isSuccess == true) {
      _categoryStreamController.sink.add(await DbCategoryService.getAll());
    }
    return result;
  }

  @override
  Future<IResult> delete(Category entity) async {
    IResult result = await DbCategoryService.delete(entity);
    if (result.isSuccess == true) {
      _categoryStreamController.sink.add(await DbCategoryService.getAll());
    }
    return result;
  }

  @override
  Future<IDataResult<List<Category>>> getAll() async {
    IDataResult result = await DbCategoryService.getAll();
    return result;
  }

  @override
  Future<IDataResult<Category>> getById(int id) async {
    IDataResult result = await DbCategoryService.getById(id);
    return result;
  }

  @override
  Future<IResult> update(Category entity) async {
    IResult result = await DbCategoryService.update(entity);
    if (result.isSuccess == true) {
      _categoryStreamController.sink.add(await DbCategoryService.getAll());
    }
    return result;
  }
}

final dbSqfliteCategoryBloc = new DbSqfliteCategoryBloc();
