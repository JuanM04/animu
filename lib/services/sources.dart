import 'package:animu/services/requests.dart';
import 'package:animu/utils/models.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class APIServer {
  final String title;
  final List<String> names;
  final Future<String> Function(
      RequestsService requestsService, String sourceCode) function;

  APIServer({this.title, this.names, this.function});
}

List<APIServer> servers = [
  APIServer(
      title: 'Natsuki/Izanagi',
      names: ['natsuki', 'amus'],
      function: (requestsService, sourceCode) async {
        final response = await requestsService.getNatsiku(sourceCode);
        return response['file'];
      }),
  APIServer(
    title: 'Fembed',
    names: ['fembed'],
    function: (_, sourceCode) async {
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

Future<String> getEpisodeURLFromData({
  PlayerData data,
  RequestsService requestsService,
}) async {
  List sources = await requestsService.getEpisodeSources(
    animeSlug: data.anime.slug,
    episode: data.currentEpisode,
  );

  final server = servers[Hive.box('settings').get('server_index')];

  int index =
      sources.indexWhere((source) => server.names.contains(source['server']));

  if (index > -1)
    return await server.function(requestsService, sources[index]['code']);
  else
    return '';
}
