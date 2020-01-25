import 'package:animu/services/error.dart';
import 'package:animu/utils/global.dart';
import 'package:animu/utils/models.dart';
import 'package:dio/dio.dart';
import 'package:graphql/client.dart';

class RequestsService {
  static final _httpLink = HttpLink(uri: Global.requestsEndpoint);
  static final _client = GraphQLClient(
    cache: InMemoryCache(),
    link: _httpLink,
  );

  static final animeFragment = """
    id
    name
    slug
    cover
    banner
    type
  """;

  static Future _query({String query, Map<String, dynamic> variables}) {
    return _client.query(QueryOptions(
      documentNode: gql(query),
      variables: variables,
    ));
  }

  static Future<dynamic> getEpisodeSources({
    String animeSlug,
    Episode episode,
  }) async {
    try {
      final response = await _query(
        query: """
          query GetEpisodeSources(\$episodeId: Int!, \$episodeN: Int!, \$animeSlug: String!) {
            episodeSources(episodeId: \$episodeId, episodeN: \$episodeN, animeSlug: \$animeSlug) {
              server
              code
            }
          }
        """,
        variables: {
          'episodeId': episode.id,
          'episodeN': episode.n,
          'animeSlug': animeSlug,
        },
      );
      return response.data['episodeSources'];
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  static Future<List<Episode>> getEpisodes(Anime anime) async {
    try {
      final response = await _query(
        query: """
          query GetEpisodes(\$animeId: Int!, \$animeSlug: String!) {
            anime(id: \$animeId, slug: \$animeSlug) {
              episodes {
                id
                n
              }
            }
          }
        """,
        variables: {
          'animeId': anime.id,
          'animeSlug': anime.slug,
        },
      );

      final episodes = response.data['anime']['episodes'];
      return new List<Episode>.from(
        episodes.map((map) => Episode.fromMap(map)),
      );
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  static Future<String> getNatsiku(String url) async {
    try {
      final response = await new Dio().post(
        '${Global.appUrl}/api/get-natsuki',
        data: url,
        options: Options(contentType: 'text/plain'),
      );

      return response.data;
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  static Future<List<Anime>> searchAnimes(String query) async {
    try {
      final response = await _query(
        query: """
          query Search(\$query: String!) {
            search(query: \$query) {
              $animeFragment
            }
          }
        """,
        variables: {'query': query},
      );

      final animes = response.data['search'];
      return new List<Anime>.from(
        animes.map((map) => Anime.fromMap(map)),
      );
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  static Future<Anime> getAnime(Anime anime) async {
    try {
      final response = await _query(
        query: """
          query GetEpisodes(\$animeId: Int!, \$animeSlug: String!) {
            anime(id: \$animeId, slug: \$animeSlug) {
              $animeFragment
            }
          }
        """,
        variables: {
          'animeId': anime.id,
          'animeSlug': anime.slug,
        },
      );

      return Anime.fromMap(response.data['anime']);
    } catch (e, s) {
      ErrorService.report(e, s);
      return null;
    }
  }

  static Future<List<Episode>> getEpisodesThumbnails(
    int animeId,
    List<Episode> episodes,
  ) async {
    final response = await new Dio().post(
      '${Global.appUrl}/api/get-episodes-images',
      data: {
        'animeId': animeId,
        'episodes': episodes.map((e) => e.toMap()).toList(),
      },
    );

    return new List<Episode>.from(
      response.data.map((map) => Episode.fromMap(map)),
    );
  }
}
