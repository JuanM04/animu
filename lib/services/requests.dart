import 'dart:convert';
import 'dart:io';

import 'package:animu/utils/models.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class RequestsService {
  var dio = new Dio();
  var jar = CookieJar();
  final mainUri = Uri.parse('https://animeflv.net');

  Map<String, String> get headers => {
        'cookie': jar
            .loadForRequest(mainUri)
            .fold<String>(
              '',
              (accum, cookie) => accum + '; ' + cookieToString(cookie),
            )
            .substring(2),
      };

  Future init() {
    return dio.get('https://animu.juanm04.com/api/get-cloudflare-id').then(
      (res) {
        jar.saveFromResponse(
          mainUri,
          [Cookie('__cfduid', res.data), Cookie('device', 'computer')],
        );
        dio.interceptors.add(CookieManager(jar));
      },
    ).catchError(print);
  }

  Future<dynamic> getEpisodeSources({String animeSlug, Episode episode}) async {
    try {
      final response = await dio.get(
          'https://animeflv.net/ver/${episode.id}/$animeSlug-${episode.n}');

      final String rawSources =
          response.data.split('var videos = ')[1].split(';')[0];
      return jsonDecode(rawSources)['SUB'];
    } catch (e) {
      await init();
      return await getEpisodeSources(animeSlug: animeSlug, episode: episode);
    }
  }

  Future<dynamic> getEpisodes({Anime anime}) async {
    try {
      final response =
          await dio.get('https://animeflv.net/anime/${anime.id}/${anime.slug}');

      final String rawSources =
          response.data.split('var episodes = ')[1].split(';')[0];
      return jsonDecode(rawSources);
    } catch (e) {
      await init();
      return await getEpisodes(anime: anime);
    }
  }

  Future<dynamic> getNatsiku(String url) async {
    try {
      final response =
          await dio.get(url.replaceFirst('embed.php', 'check.php'));

      return jsonDecode(response.data);
    } catch (e) {
      await init();
      return await getNatsiku(url);
    }
  }

  Future<dynamic> searchAnimes(String query) async {
    try {
      final response = await dio.post(
        'https://animeflv.net/api/animes/search',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {'value': query},
      );

      return response.data;
    } catch (e) {
      await init();
      return await searchAnimes(query);
    }
  }
}

String cookieToString(Cookie cookie) => cookie.name + '=' + cookie.value;
