import 'package:flutter_meal_app_update/blocs/abstract/i_base_bloc.dart';
import 'package:flutter_meal_app_update/core/utilities/results/i_data_result.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

abstract class IRecipeBloc implements IBaseBloc<Recipe> {
  Future<IDataResult<List<Recipe>>> getAllByCategoryId(int categoryId);
}
