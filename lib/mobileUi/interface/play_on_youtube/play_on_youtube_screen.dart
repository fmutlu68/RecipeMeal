import 'package:flutter/material.dart';
import 'package:flutter_meal_app_update/models/concrete/recipe.dart';
import 'package:flutter_meal_app_update/core/extensions/device_size_extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayOnYoutubeScreen extends StatefulWidget {
  final Recipe recipe;

  const PlayOnYoutubeScreen({Key key, this.recipe}) : super(key: key);

  @override
  _PlayOnYoutubeScreenState createState() => _PlayOnYoutubeScreenState();
}

class _PlayOnYoutubeScreenState extends State<PlayOnYoutubeScreen> {
  YoutubePlayerController ytController;
  double videoSeconds = 0.0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    ytController = new YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.recipe.recipeLink),
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    isPaused = ytController.value.isPlaying;
    ytController.addListener(() {
      if (videoSeconds !=
          ytController.value.position.inSeconds.ceilToDouble()) {
        setState(() {
          videoSeconds = ytController.value.position.inSeconds.ceilToDouble();
          isPaused = !ytController.value.isPlaying;
        });
      }

      if (ytController.metadata.duration.inSeconds.roundToDouble() != 0.0 &&
          videoSeconds ==
              ytController.metadata.duration.inSeconds.roundToDouble()) {
        ytController.pause();
        setState(() {
          isPaused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ytController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Youtube Video İzle"),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
            width: double.maxFinite,
            controller: ytController,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
              ),
              PlaybackSpeedButton(),
              FullScreenButton(),
            ]),
        builder: (context, player) {
          return Column(
            children: [
              player,
              _getRecipeDetail,
            ],
          );
        },
      ),
    );
  }

  Container get _getRecipeDetail => Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.symmetric(
          horizontal: context.calculateByPercentage(
            2,
            SideTypes.HORIZONTAL,
          ),
          vertical: context.calculateByPercentage(
            2,
            SideTypes.VERTICAL,
          ),
        ),
        width: context.calculateByPercentage(
          95,
          SideTypes.HORIZONTAL,
        ),
        height: context.calculateByPercentage(
          22,
          SideTypes.VERTICAL,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.calculateByPercentage(
              10,
              SideTypes.HORIZONTAL,
            ),
          ),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getVideoSliderButtonBar,
            _getVideoDurationButtonBar,
            _getPlayOrPauseButton,
          ],
        ),
      );
  Container get _getVideoSliderButtonBar => Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.calculateByPercentage(
            3,
            SideTypes.HORIZONTAL,
          ),
        ),
        child: Row(
          children: [
            _getVideoSecondsInfoMessage,
            Flex(
              direction: Axis.horizontal,
              children: [_getVideoSliderContainer],
            ),
          ],
        ),
      );
  Chip get _getVideoSecondsInfoMessage {
    var duration = Duration(seconds: videoSeconds.ceil());
    var minutesDurationText =
        duration.inMinutes < 10 ? '0${duration.inMinutes}' : duration.inMinutes;
    var secondsDurationText = duration.inSeconds < 10
        ? '0${duration.inSeconds}'
        : duration.inSeconds > 60
            ? duration.inSeconds - 60 * duration.inMinutes
            : duration.inSeconds;
    return Chip(
      label: Text("$minutesDurationText:$secondsDurationText"),
    );
  }

  Container get _getVideoSliderContainer => Container(
        width: context.calculateByPercentage(
          70,
          SideTypes.HORIZONTAL,
        ),
        child: _getVideoSlider,
      );
  Slider get _getVideoSlider => Slider(
        value: videoSeconds,
        onChanged: (value) {
          ytController.seekTo(
            new Duration(
              seconds: value.ceil(),
            ),
          );
        },
        max: ytController.metadata.duration.inSeconds.roundToDouble(),
        min: 0,
      );
  ButtonBar get _getVideoDurationButtonBar => ButtonBar(
        alignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _getSkipPreviousButton,
          _getSkipNextButton,
        ],
      );
  ElevatedButton get _getSkipPreviousButton => ElevatedButton.icon(
        onPressed: () => seekPrevious(),
        label: Text(
          "10 Sn Geri",
        ),
        icon: Icon(
          Icons.skip_previous,
        ),
        style: _coloredButtonTheme,
      );

  ElevatedButton get _getSkipNextButton => ElevatedButton(
        onPressed: () => seekNext(),
        child: Row(
          children: [
            Text(
              "10 Sn İleri",
            ),
            SizedBox(
              width: context.calculateByPercentage(
                1.1,
                SideTypes.HORIZONTAL,
              ),
            ),
            Icon(Icons.skip_next),
          ],
        ),
        style: _coloredButtonTheme,
      );

  ElevatedButton get _getPlayOrPauseButton {
    if (!isPaused) {
      return ElevatedButton.icon(
        onPressed: playOrPause,
        label: Text("Duraklat"),
        icon: Icon(
          Icons.pause,
        ),
        style: _coloredButtonTheme,
      );
    } else {
      return ElevatedButton.icon(
        onPressed: playOrPause,
        icon: Icon(Icons.play_arrow),
        label: Text("Devam Ettir"),
        style: _coloredButtonTheme,
      );
    }
  }

  get _coloredButtonTheme => OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.background,
      );

  seekPrevious() {
    Duration durationPrevious;
    if (ytController.value.position.inSeconds < 10) {
      durationPrevious = Duration(seconds: 0);
    } else {
      durationPrevious = (ytController.value.position) - Duration(seconds: 10);
    }
    setState(() {
      ytController.seekTo(durationPrevious);
    });
  }

  seekNext() {
    Duration durationNext =
        (ytController.value.position) + Duration(seconds: 10);
    setState(() {
      ytController.seekTo(durationNext);
    });
  }

  playOrPause() {
    if (ytController.value.isPlaying) {
      ytController.pause();
    } else {
      ytController.play();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }
}
