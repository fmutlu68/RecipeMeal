import 'dart:io';
import 'dart:math';

import 'package:flutter_meal_app_update/models/concrete/utility.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_category_bloc.dart';
import 'package:flutter_meal_app_update/blocs/concrete/sqflite/db_sqflite_recipe_bloc.dart';
import 'package:flutter_meal_app_update/data/abstract/i_video_downloader_service.dart';
import 'package:flutter_meal_app_update/models/concrete/category.dart';
import 'package:flutter_meal_app_update/models/concrete/downloading_audio.dart';
import 'package:flutter_meal_app_update/models/concrete/downloading_video.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class YoutubeDownloaderManager implements IVideoDownloaderService {
  static YoutubeDownloaderManager _instance;
  static YoutubeDownloaderManager get instance {
    _instance ??= YoutubeDownloaderManager._init();
    return _instance;
  }

  YoutubeDownloaderManager._init() {
    _youtubeExplode = new YoutubeExplode();
  }

  YoutubeExplode _youtubeExplode;

  DownloadingVideo _downloadingVideo;
  DownloadingVideo get getVideo => _downloadingVideo;

  DownloadingAudio _downloadingAudio;
  DownloadingAudio get getAudio => _downloadingAudio;
  @override
  Future<void> downloadAudio(Recipe recipe) async {
    _downloadingAudio = new DownloadingAudio();
    _downloadingAudio.setDownloadingState =
        "Sadece Ses İndirme İşlemi Başlatldı...";
    var videoCategory = await dbSqfliteCategoryBloc.getById(recipe.categoryId);
    Directory(videoCategory.data.path).createSync();
    recipe.recipeLink = recipe.recipeLink.trim();

    StreamManifest manifest = await _youtubeExplode.videos.streamsClient
        .getManifest(recipe.recipeLink);
    _downloadingAudio.setDownloadingState =
        "Video Hakkında Bilgi Toplanıyor...";
    Iterable<AudioOnlyStreamInfo> streams = manifest.audioOnly;

    var audio = streams.withHighestBitrate();
    var audioStream = _youtubeExplode.videos.streamsClient.get(audio);

    _downloadingAudio.setDownloadingState = "Ses Dosyası Hazırlanıyor...";

    var fileName = '${recipe.recipeName}.${audio.container.name.toString()}'
        .replaceAll(r'\', '')
        .replaceAll('/', '')
        .replaceAll("(", " ")
        .replaceAll('*', '')
        .replaceAll('?', '')
        .replaceAll('"', '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('|', '')
        .replaceAll("(", " ")
        .replaceAll(")", " ")
        .replaceAll("#", "sharp");
    _downloadingAudio.setName = fileName;
    _downloadingAudio.setDownloadingState = "Ses Dosyası Oluşturuluyor...";
    var file = new File('${videoCategory.data.path}/$fileName');

    if (file.existsSync()) {
      file.deleteSync();
    }
    var output = file.openWrite(mode: FileMode.writeOnlyAppend);

    double len = audio.size.totalBytes.toDouble();
    double count = 0;

    _downloadingAudio.setDownloadingState = "Ses İndiriliyor...";

    await for (var data in audioStream) {
      count += data.length.toDouble();

      double progress = ((count / len) / 1);

      _downloadingAudio.setStatus = progress;

      output.add(data);
    }
    _downloadingAudio.setSize = getSize(file.lengthSync(), 1);
    _downloadingAudio.setDownloadingState = "Ses İndirilme İşlemi Başarılı.";
    _downloadingAudio.setPath = file.path;
    recipe.localAudioFilePath = file.path;
    dbSqfliteRecipeBloc.update(recipe);
  }

  @override
  Future<void> downloadVideo(Recipe recipe) async {
    _downloadingVideo = new DownloadingVideo();
    _downloadingVideo.setQuality = "Bekleyin...";
    _downloadingVideo.setDownloadingState = "Video İndirme İşlemi Başlatıldı.";
    Category category =
        (await dbSqfliteCategoryBloc.getById(recipe.categoryId)).data;
    recipe.recipeLink = recipe.recipeLink.trim();
    var manifest = await _youtubeExplode.videos.streamsClient
        .getManifest(recipe.recipeLink);
    _downloadingVideo.setDownloadingState =
        "Video Hakkında Bilgi Toplanıyor...";
    var streams = manifest.muxed
        .where((element) => element.videoQualityLabel == "1080p60");
    _downloadingVideo.setQuality = "UHD 1080p 60 fps";
    if (streams.isEmpty || streams == null) {
      streams = manifest.muxed
          .where((element) => element.videoQualityLabel == "1080p");
      _downloadingVideo.setQuality = "HD 1080p";
    }
    if (streams.isEmpty || streams == null) {
      streams = manifest.muxed
          .where((element) => element.videoQualityLabel == "720p");
      _downloadingVideo.setQuality = "HD 720p";
    }
    if (streams == null || streams.isEmpty) {
      streams = manifest.muxed;
      _downloadingVideo.setQuality = "SD 360p";
    }

    _downloadingVideo.setDownloadingState = "Video Dosyası Hazırlanıyor...";
    var audio = streams.withHighestBitrate();
    var audioStream = _youtubeExplode.videos.streamsClient.get(audio);
    var fileName = '${recipe.recipeName}.${audio.container.name.toString()}'
        .replaceAll(r'\', '')
        .replaceAll('/', '')
        .replaceAll('*', '')
        .replaceAll('?', '')
        .replaceAll('"', '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll('|', '')
        .replaceAll("#", "sharp");
    _downloadingVideo.setName = fileName;
    _downloadingVideo.setDownloadingState = "Video Dosyası Oluşturuluyor...";
    var file = new File("${category.path.replaceAll(r"\", "/")}/$fileName");
    if (file.existsSync()) {
      file.deleteSync();
    }
    var output = file.openWrite(mode: FileMode.writeOnlyAppend);

    double len = audio.size.totalBytes.toDouble();
    double count = 0;

    _downloadingVideo.setDownloadingState = "Video İndiriliyor...";
    int allData = 0;
    await for (var data in audioStream) {
      allData += data.length;
      count += data.length.toDouble();
      double progress = ((count / len) / 1);
      _downloadingVideo.setStatus = progress;
      output.add(data);
    }
    _downloadingVideo.setSize = getSize(allData, 1);
    _downloadingVideo.setDownloadingState = "Video İndirme İşlemi Başarılı.";
    _downloadingVideo.setPath = file.path;
    recipe.localVideoFilePath = file.path;
    print("Video Path: ${recipe.localVideoFilePath}");
    recipe.videoQuality = _downloadingVideo.getQuality;
    dbSqfliteRecipeBloc.update(recipe);
  }

  @override
  Future<Recipe> getRecipeIngredients(Recipe recipe) async {
    var video = await _youtubeExplode.videos.get(recipe.recipeLink);
    recipe.ingredients = video.description;
    return recipe;
  }

  getSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
    print(
        ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i]);
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  @override
  Future<String> getVideoImage(String recipeLink) async {
    var url = Uri.https("img.youtube.com",
        "/vi/${recipeLink.substring(recipeLink.length - 11)}/0.jpg");
    http.Response response = await http.get(url);
    return Utility.base64String(response.bodyBytes);
  }
}
