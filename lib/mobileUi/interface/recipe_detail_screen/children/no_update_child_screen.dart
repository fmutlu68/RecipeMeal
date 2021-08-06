import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class NoUpdateChildScreen extends StatelessWidget {
  final Recipe recipe;
  const NoUpdateChildScreen({Key key, this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getListView(
      context,
    );
  }

  _getListView(BuildContext context) => ListView(
        padding: EdgeInsets.symmetric(
          vertical: context.calculateByPercentage(
            3,
            SideTypes.VERTICAL,
          ),
          horizontal: context.calculateByPercentage(
            3,
            SideTypes.HORIZONTAL,
          ),
        ),
        children: [
          _getRecipeNameWidget(context),
        ],
      );

  _getRecipeNameWidget(BuildContext context) => buildCard(
        context,
        buildTile(
          context,
          "Tarif İsmi",
          recipe.recipeName,
        ),
      );

  buildCard(BuildContext context, child) => Card(
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            context.calculateByPercentage(10, SideTypes.HORIZONTAL),
          ),
        ),
        child: child,
      );

  buildTile(BuildContext context, infoMessage, mainMessage) => ListTile(
        leading: CircleAvatar(
          child: Icon(
            Icons.info,
          ),
          foregroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        subtitle: Text(
          infoMessage,
        ),
        title: Text(
          mainMessage,
        ),
        // tileColor: ,
      );
}
