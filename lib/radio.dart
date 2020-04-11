import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'models/queue_item.dart';
import 'mstream_player.dart';

class RadioGaGa {
  var serverUrl = 'http://localhost:3030';

  MstreamPlayer mStreamPlayer;

  RadioGaGa() {
    this.mStreamPlayer = new MstreamPlayer();
    this.loadSongs();
  }

  void play() {
    this.mStreamPlayer.playRandomSong();
  }

  Future<void> loadSongs() async {
    var res = await _makeServerCall(
        serverUrl, '/dirparser', {"dir": "music"}, 'POST');
    if (res == null) {
      return;
    }

    res['contents'].forEach((e) {
      Uri url = Uri.parse(serverUrl + '/media/music/' + e['name']);
      QueueItem song =
          new QueueItem(null, e['name'], url.toString(), null, null);

      mStreamPlayer.addSong(song);
    });
  }

  Future _makeServerCall(
      String serverURL, String location, Map payload, String getOrPost) async {
    String url = serverURL + location;
    var response;
    if (getOrPost == 'GET') {
      response = await http.get(url);
    } else {
      response = await http.post(url, body: payload);
    }

    if (response.statusCode > 299) {
      Fluttertoast.showToast(
          msg: "Server Call Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white);
      return null;
    }

    var res = jsonDecode(response.body);

    return res;
  }
}
