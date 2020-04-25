import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class DoubanFm {
  final String fmPlaylistUrl =
      'https://api.douban.com/v2/fm/playlist?channel=-10&kbps=128&app_name=radio_android&version=100&type=n';
  final String defaultSong = 'Carla-Bruni-You-Belong-To-Me.mp3';

  // for playing douban fm
  static AudioPlayer audioPlayer;
  Song nextSong;

  // for playing default song
  static AudioCache cachePlayer = AudioCache();
  AudioPlayer cachePlayerControl;

  DoubanFm() {
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerCompletion.listen((event) {
      play();
    });
    _prefetchNextSong();

    cachePlayer.load(defaultSong);
  }

  play() {
    // stop playing if another alarm already went off
    stop();

    if (nextSong != null) {
      audioPlayer.play(nextSong.url);
      print('Playing: ${nextSong.artist} - ${nextSong.title}');
      _prefetchNextSong();
    } else {
      _playDefaultSong();
    }
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

  _prefetchNextSong() {
    http.get(fmPlaylistUrl).then((res) {
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        List songList = body['song'];

        if (songList.length > 0) {
          var song = songList[0];
          String artist = song['artist'];
          String title = song['title'];
          String url = song['url'];
          nextSong = Song(title, artist, url);
          print('Prefetched: ${nextSong.artist} - ${nextSong.title}');
        } else {
          throw ('Song list is empty.');
        }
      } else {
        throw ('Http error response.');
      }
    }).catchError((e) {
      print("Got error: ${e.error}");
      return 42; // Future completes with 42.
    });
  }
}

class Song {
  String title;
  String artist;
  String url;

  Song(
    this.title,
    this.artist,
    this.url,
  );
}
