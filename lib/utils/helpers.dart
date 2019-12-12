import 'dart:convert';
import 'package:animu/utils/classes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<dynamic> getJSONFromServer(
  String endpoint,
  Map<String, String> query,
) async {
  Response response = await new Dio().get(
    'https://animu.juanm04.com/api' + endpoint,
    queryParameters: query,
  );
  return response.data;
}

String formatDuration(Duration duration) {
  bool hours = duration.inHours > 0;
  String _twoDigits(int n) {
    if (n >= 10)
      return "$n";
    else
      return "0$n";
  }

  String finalSeconds = _twoDigits(duration.inSeconds.remainder(60));
  int remainingMinutes = duration.inMinutes.remainder(60);
  String finalMinutes =
      hours ? _twoDigits(remainingMinutes) : remainingMinutes.toString();
  String mmSs = '$finalMinutes:$finalSeconds';

  return hours ? '${duration.inHours.toString()}:$mmSs' : mmSs;
}

List<APIServer> serverPriorityList = [
  APIServer(
      name: 'natsuki',
      function: (sourceCode) async {
        var dio = new Dio();
        var response =
            await dio.post(sourceCode.replaceFirst('embed.php', 'check.php'));
        return jsonDecode(response.data)['file'];
      }),
  APIServer(
    name: 'fembed',
    function: (String sourceCode) async {
      int _quality(Map video) =>
          int.parse(video['label'].replaceFirst('p', ''));

      var dio = new Dio();
      var response =
          await dio.post(sourceCode.replaceFirst('/v/', '/api/source/'));
      List videos = response.data['data'];

      var bestQualityVideo = videos[0];
      videos.forEach((video) {
        if (_quality(bestQualityVideo) < _quality(video))
          bestQualityVideo = video;
      });

      Response file = await dio.get(
        bestQualityVideo['file'],
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status < 400,
        ),
      );
      return file.headers.value('location');
    },
  ),
];

Future<String> getEpisodeURLFromData(PlayerData data) async {
  List sources = (await getJSONFromServer('/get-episode-sources', {
    'anime_slug': data.anime.slug,
    'episode_id': data.currentEpisode.id.toString(),
    'episode_n': data.currentEpisode.n.toString(),
  }));

  for (APIServer server in serverPriorityList) {
    int index = sources.indexWhere((source) => source['server'] == server.name);

    if (index > -1) {
      return await server.function(sources[index]['code']);
    }
  }
  return '';
}

Widget dialogButton(String label, Function onPressed) => FlatButton(
      onPressed: onPressed,
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      textColor: Colors.white,
    );
