import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DoubanFm {
  final AudioPlayer audioPlayer = AudioPlayer();
  final String fmPlaylistUrl =
      'https://api.douban.com/v2/fm/playlist?channel=-10&kbps=128&app_name=radio_android&version=100&type=n';

  List<String> songUrlList = [];
  bool playing;

  play() async {
    Response res = await http.get(fmPlaylistUrl);

    var body = jsonDecode(res.body);
    print(body);

    List songList = body['song'];
    songUrlList = songList.map((s) => s['url'].toString()).toList();

    if (songUrlList.length > 0) {
      int result = await audioPlayer.play(songUrlList[0]);
      if (result == 1) {
        // success
        playing = true;
      }
    }
  }

  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      playing = false;
    }
  }
}
