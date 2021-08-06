import 'package:flutter/material.dart';

import 'package:flutter_meal_app_update/models/abstract/i_entity.dart';

class Recipe implements IEntity {
  static final columnId = ["id", "INTEGER"];
  static final columnCategoryId = ["category_id", "INTEGER"];
  static final columnRecipeName = ["recipe_name", "TEXT"];
  static final columnIngredients = ["ingredients", "TEXT"];
  static final columnRecipeLink = ["recipe_link", "TEXT"];
  static final columnImage64 = ["image_64", "TEXT"];
  static final columnLocalVideoFilePath = ["local_video_file_path", "TEXT"];
  static final columnVideoQuality = ["video_quality", "TEXT"];
  static final columnLocalAudioFilePath = ["local_audio_file_path", "TEXT"];

  @override
  int id;
  int categoryId;

  String recipeName;
  String ingredients;
  String recipeLink;
  String image64;
  String localVideoFilePath;
  String localAudioFilePath;
  String videoQuality;

  bool isVideoDownloaded;
  bool isAudioDownloaded;

  IconData selectedVideoDownloadedIcon;
  IconData selectedAudioDownloadedIcon;
  Recipe(
      {this.recipeName,
      this.recipeLink,
      this.ingredients,
      this.image64,
      this.localAudioFilePath,
      this.localVideoFilePath,
      this.categoryId,
      this.videoQuality}) {
    _checkVideoFile();
    _checkAudioFile();
  }
  Recipe.empty();
  Recipe.withId(
      {this.id,
      this.recipeName,
      this.recipeLink,
      this.ingredients,
      this.image64,
      this.localAudioFilePath,
      this.localVideoFilePath,
      this.categoryId,
      this.videoQuality}) {
    _checkVideoFile();
    _checkAudioFile();
  }
  Recipe.fromData(dynamic object) {
    if (object["id"] != null && object["id"].runtimeType == int) {
      this.id = object["id"];
    }
    recipeName = object["recipe_name"];
    recipeLink = object["recipe_link"];
    ingredients = object["ingredients"];
    isVideoDownloaded = false;
    selectedVideoDownloadedIcon = Icons.download_rounded;
    isAudioDownloaded = false;
    selectedAudioDownloadedIcon = Icons.download_rounded;
    isVideoDownloaded = false;
    if (object["image_64"] != null &&
        object["image_64"].runtimeType == String) {
      image64 = object["image_64"];
    }
    if (object["local_audio_file_path"] != null &&
        object["local_audio_file_path"].runtimeType == String) {
      localAudioFilePath = object["local_audio_file_path"];
      isAudioDownloaded = true;
      selectedAudioDownloadedIcon = Icons.music_video;
    }
    if (object["local_video_file_path"] != null &&
        object["local_video_file_path"].runtimeType == String) {
      localVideoFilePath = object["local_video_file_path"];
      isVideoDownloaded = true;
      selectedVideoDownloadedIcon = Icons.live_tv;
      videoQuality = object["video_quality"];
    }
    categoryId = object["category_id"];
  }
  @override
  get getEntityName => "Tarif";

  _checkAudioFile() {
    if (localAudioFilePath.runtimeType == String &&
        localAudioFilePath != null) {
      isAudioDownloaded = true;
      selectedAudioDownloadedIcon = Icons.download_done_rounded;
    } else {
      isAudioDownloaded = false;
      selectedAudioDownloadedIcon = Icons.download_rounded;
    }
  }

  _checkVideoFile() {
    if (localVideoFilePath.runtimeType == String &&
        localVideoFilePath != null) {
      isVideoDownloaded = true;
      selectedVideoDownloadedIcon = Icons.download_done_rounded;
    } else {
      isVideoDownloaded = false;
      selectedVideoDownloadedIcon = Icons.download_rounded;
    }
  }

  @override
  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> map = new Map();
    if (id.runtimeType == int) {
      map["id"] = id;
    }
    map["recipe_name"] = recipeName;
    map["recipe_link"] = recipeLink;
    map["ingredients"] = ingredients;
    if (image64.runtimeType == String) {
      map["image_64"] = image64;
    }
    if (localAudioFilePath.runtimeType == String) {
      map["local_audio_file_path"] = localAudioFilePath;
    }
    if (localVideoFilePath.runtimeType == String) {
      map["local_video_file_path"] = localVideoFilePath;
      map["video_quality"] = videoQuality;
    }
    map["category_id"] = categoryId;
    return map;
  }

  @override
  String toString() {
    return "$recipeName $ingredients $recipeLink";
  }
}
