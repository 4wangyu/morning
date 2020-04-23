import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class DoubanFm {
  final String fmPlaylistUrl =
      'https://api.douban.com/v2/fm/playlist?channel=-10&kbps=128&app_name=radio_android&version=100&type=n';
  final String defaultSong = 'Carla-Bruni-You-Belong-To-Me.mp3';

  static AudioPlayer audioPlayer;
  static AudioCache cachePlayer = AudioCache();
  AudioPlayer cachePlayerControl;

  DoubanFm() {
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerCompletion.listen((event) {
      play();
    });

    cachePlayer.load(defaultSong);
  }

  play() {
    http.get(fmPlaylistUrl).then((res) {
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List songList = body['song'];

        if (songList.length > 0) {
          var song = songList[0];
          String artist = song['artist'];
          String title = song['title'];
          print('Playing: $artist - $title');
          audioPlayer.play(song['url']);
        } else {
          throw ('Song list is empty.');
        }
      } else {
        throw ('Http error response.');
      }
    }).catchError((e) {
      print("Got error: ${e.error}");
      _playDefaultSong();
      return 42; // Future completes with 42.
    });
  }

  stop() {
    audioPlayer.stop();

    if (cachePlayerControl != null) {
      cachePlayerControl.stop();
    }
  }

  _playDefaultSong() {
    cachePlayer.loop(defaultSong).then((control) {
      cachePlayerControl = control;
    });
  }
}
