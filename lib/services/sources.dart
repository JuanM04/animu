import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:dio/dio.dart';

class APIServer {
  final List<String> names;
  Future<String> Function(String sourceCode) function;

  APIServer({this.names, this.function});
}

List<APIServer> serverPriorityList = [
  APIServer(
      names: ['natsuki', 'amus'],
      function: (sourceCode) async {
        final response =
            await getJSONFromServer('/get-natsuki', {'url': sourceCode});
        return response['file'];
      }),
  APIServer(
    names: ['fembed'],
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
    int index =
        sources.indexWhere((source) => server.names.contains(source['server']));

    if (index > -1) return await server.function(sources[index]['code']);
  }
  return '';
}