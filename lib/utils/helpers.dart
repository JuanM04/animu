import 'dart:convert';
import 'package:animu/utils/models.dart';
import 'package:dio/dio.dart';

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

//
// Watching State
//
int watchingStateToInt(WatchingState watchingState) {
  if (watchingState == WatchingState.toWatch)
    return 1;
  else if (watchingState == WatchingState.watching)
    return 2;
  else if (watchingState == WatchingState.watched)
    return 3;
  else
    return 0;
}

WatchingState intToWatchingState(int n) {
  if (n == 1)
    return WatchingState.toWatch;
  else if (n == 2)
    return WatchingState.watching;
  else if (n == 3)
    return WatchingState.watched;
  else
    return null;
}
