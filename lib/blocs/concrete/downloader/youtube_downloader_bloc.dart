import 'dart:async';

import 'package:flutter_meal_app_update/blocs/abstract/i_downloader_bloc.dart';
import 'package:flutter_meal_app_update/data/concrete/downloaders/youtube_downloader_manager.dart';
import 'package:flutter_meal_app_update/models/concrete/downloading_audio.dart';
import 'package:flutter_meal_app_update/models/concrete/downloading_video.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';

class VideoDownloaderBloc implements IDownloaderBloc {
  DownloadingAudio get getAudio => YoutubeDownloaderManager.instance.getAudio;

  DownloadingVideo get getVideo => YoutubeDownloaderManager.instance.getVideo;

  Future<void> downloadVideo(Recipe recipe) async {
    await YoutubeDownloaderManager.instance.downloadVideo(recipe);
  }

  Future<void> downloadAudio(Recipe recipe) async {
    await YoutubeDownloaderManager.instance.downloadVideo(recipe);
  }

  Future<String> getVideoImage64(String videoLink) {
    return YoutubeDownloaderManager.instance.getVideoImage(videoLink);
  }
}

final youtubeDownloaderBloc = new VideoDownloaderBloc();
