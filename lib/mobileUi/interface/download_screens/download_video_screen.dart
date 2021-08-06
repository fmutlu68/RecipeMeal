import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/core/widgets/snack_bar_manager.dart';
import 'package:flutter_meal_app_update/data/concrete/downloaders/youtube_downloader_manager.dart';
import 'package:flutter_meal_app_update/models/concrete/downloading_video.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';

class DownloadVideoScreen extends StatefulWidget {
  final Recipe recipe;

  const DownloadVideoScreen(this.recipe);
  @override
  _DownloadVideoScreenState createState() => _DownloadVideoScreenState();
}

class _DownloadVideoScreenState extends State<DownloadVideoScreen> {
  Timer timer;
  DownloadingVideo _downloadingVideo;

  get _lightTextStyle => TextStyle(color: Colors.white);
  get _darkTextStyle => TextStyle(color: Colors.black);

  @override
  void initState() {
    super.initState();
    _downloadingVideo = new DownloadingVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _scaffoldBodyContent,
      floatingActionButton: _downloadButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }

  SizedBox _box(_height) => SizedBox(
        height: _height,
      );

  AppBar get _appBar => AppBar(
        title: _appBarTitle,
      );

  Widget get _appBarTitle => Text("Video İndirme Ekranı");

  get _downloadButton {
    return timer == null
        ? FloatingActionButton(
            child: Icon(Icons.download_rounded),
            tooltip: "Video İndirmeyi Başlat",
            onPressed: () {
              settingState();
              YoutubeDownloaderManager.instance
                  .downloadVideo(widget.recipe)
                  .then((_) {
                SnackBarManager.showSuccessSnackBar(
                  Text(_downloadingVideo.getDownloadingState),
                  context: context,
                );
                setState(() {
                  _downloadingVideo =
                      YoutubeDownloaderManager.instance.getVideo;
                });
              });
            },
          )
        : null;
  }

  Widget get _scaffoldBodyContent {
    return Platform.isAndroid || Platform.isFuchsia || Platform.isIOS
        ? Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.calculateByPercentage(
                  4,
                  SideTypes.VERTICAL,
                ),
                horizontal: context.calculateByPercentage(
                  4,
                  SideTypes.HORIZONTAL,
                )),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                buildVideoNameWidget,
                _box(20.0),
                buildCategoryIdWidget,
                _box(20.0),
                buildVideoLinkWidget,
                _box(20.0),
                buildVideoDownloadingStateWidget,
                _box(20.0),
                buildVideoQualityWidget,
                _box(20.0),
                buildVideoStaticsWidget,
                _box(20.0),
                buildNameWidget,
                _box(20.0),
                buildVideoDownloaderStatusBar,
              ],
            ),
          )
        : ListView(
            scrollDirection: Axis.vertical,
            children: [
              buildTopFlexWidget,
              _box(20.0),
              buildCenterFlexWidget,
              _box(20.0),
              buildNameWidget,
              _box(20.0),
              buildVideoDownloaderStatusBar,
            ],
          );
  }

  ListTile get buildNameWidget => ListTile(
        tileColor: Colors.indigo,
        subtitle: Text(
          "Videonun İsmi --- Toplam Boyutu",
          style: _lightTextStyle,
        ),
        title: Text(
          _downloadingVideo.getSize.length == 0
              ? _downloadingVideo.getName
              : _downloadingVideo.getName + " --- " + _downloadingVideo.getSize,
          style: _lightTextStyle,
        ),
      );

  LinearProgressIndicator get buildVideoDownloaderStatusBar =>
      LinearProgressIndicator(
        backgroundColor: Colors.brown,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
        value: _downloadingVideo.getStatus,
        minHeight: 50,
      );

  Flex get buildCenterFlexWidget => Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: buildVideoDownloadingStateWidget,
            flex: 3,
          ),
          Flexible(
            child: SizedBox(
              width: 20.0,
            ),
            flex: 1,
          ),
          Flexible(
            child: buildVideoQualityWidget,
            flex: 3,
          ),
          Flexible(
            child: SizedBox(
              width: 20.0,
            ),
            flex: 1,
          ),
          Flexible(
            child: buildVideoStaticsWidget,
            flex: 3,
          ),
        ],
      );

  ListTile get buildVideoStaticsWidget => ListTile(
        tileColor: Colors.deepPurple,
        title: Text(
          "%" + (_downloadingVideo.getStatus * 100).toInt().toString(),
          style: _lightTextStyle,
        ),
        subtitle: Text(
          "Video Dosyasının İndirilme Yüzdeliği",
          style: _lightTextStyle,
        ),
      );

  ListTile get buildVideoQualityWidget => ListTile(
        tileColor: Colors.deepPurple,
        title: Text(
          _downloadingVideo.getQuality,
          style: _lightTextStyle,
        ),
        subtitle: Text(
          "Videonun Görüntü Kalitesi",
          style: _lightTextStyle,
        ),
      );

  ListTile get buildVideoDownloadingStateWidget => ListTile(
        tileColor: Colors.deepPurple,
        title: Text(
          _downloadingVideo.getDownloadingState,
          style: _lightTextStyle,
        ),
        subtitle: Text(
          "Video Dosyasının İndirilme Durumu",
          style: _lightTextStyle,
        ),
        trailing: _downloadingVideo.getStatus > 0.0 &&
                _downloadingVideo.getStatus < 1.0
            ? CircularProgressIndicator()
            : Icon(
                widget.recipe.selectedVideoDownloadedIcon,
              ),
      );

  Flex get buildTopFlexWidget => Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: buildVideoNameWidget,
            flex: 3,
          ),
          Flexible(
            child: SizedBox(
              width: 20.0,
            ),
            flex: 1,
          ),
          Flexible(
            child: buildCategoryIdWidget,
            flex: 3,
          ),
          Flexible(
            child: SizedBox(
              width: 20.0,
            ),
            flex: 1,
          ),
          Flexible(
            child: buildVideoLinkWidget,
            flex: 3,
          ),
        ],
      );

  get buildVideoNameWidget => ListTile(
        tileColor: Colors.orange,
        title: Text(
          widget.recipe.recipeName,
          style: _darkTextStyle,
        ),
        subtitle: Text(
          "Video Adı",
          style: _darkTextStyle,
        ),
      );

  get buildCategoryIdWidget => ListTile(
        tileColor: Colors.orange,
        title: Text(
          widget.recipe.categoryId.toString(),
          style: _darkTextStyle,
        ),
        subtitle: Text(
          "Videonun Kategori Numarası",
          style: _darkTextStyle,
        ),
      );

  get buildVideoLinkWidget => ListTile(
        tileColor: Colors.orange,
        title: Text(
          widget.recipe.recipeLink,
          style: _darkTextStyle,
        ),
        subtitle: Text(
          "Videonun Youtube Linki",
          style: _darkTextStyle,
        ),
      );

  void settingState() {
    timer = Timer.periodic(
      Duration(milliseconds: 50),
      (Timer t) => setState(() {
        _downloadingVideo =
            YoutubeDownloaderManager.instance.getVideo ?? _downloadingVideo;
        if (_downloadingVideo.getStatus == 1.0) {
          timer.cancel();
        }
      }),
    );
  }
}
