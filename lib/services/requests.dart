import 'package:animu/utils/models.dart';
import 'package:dio/dio.dart';
import 'package:graphql/client.dart';

class RequestsService {
  static final _httpLink =
      HttpLink(uri: 'https://animeflv.juanm04.com/graphql');
  static final _client = GraphQLClient(
    cache: InMemoryCache(),
    link: _httpLink,
  );

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
    } catch (e) {
      return await getEpisodeSources(animeSlug: animeSlug, episode: episode);
    }
  }

  static Future<dynamic> getEpisodes({Anime anime}) async {
    try {
      final response = await _query(
        query: """
          query GetEpisodes(\$animeId: Int!, \$animeSlug: String!) {
            anime(id: \$animeId, slug: \$animeSlug) {
              episodes {
                id
                n
                thumbnail
              }
            }
          }
        """,
        variables: {
          'animeId': anime.id,
          'animeSlug': anime.slug,
        },
      );
      return response.data['anime']['episodes'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> getNatsiku(String url) async {
    try {
      final response =
          await new Dio().get(url.replaceFirst('embed.php', 'check.php'));

      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> searchAnimes(String query) async {
    try {
      final response = await _query(
        query: """
          query Search(\$query: String!) {
            search(query: \$query) {
              id
              name
              slug
              cover
            }
          }
        """,
        variables: {'query': query},
      );
      return response.data['search'];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
