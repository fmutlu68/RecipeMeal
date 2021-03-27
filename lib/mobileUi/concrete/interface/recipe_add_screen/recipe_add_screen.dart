import 'package:flutter/material.dart';

class RecipeAddScreen extends StatefulWidget {
  RecipeAddScreen({Key key}) : super(key: key);

  @override
  _RecipeAddScreeState createState() => _RecipeAddScreeState();
}

class _RecipeAddScreeState extends State<RecipeAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: getImageWidget(),
              title: Text("Tarif Ekleme Ekranı"),
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }

  getImageWidget() {
    return Image.asset(
      "assets/images/empty_food.jpg",
      fit: BoxFit.fill,
      color: Colors.black.withOpacity(0.5),
      colorBlendMode: BlendMode.darken,
    );
  }
}
