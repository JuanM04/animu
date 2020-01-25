import 'package:animu/services/backup.dart';
import 'package:animu/services/requests.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:hive/hive.dart';

class AnimeDatabaseService {
  static final _box = Hive.box<Anime>('animes');
  static final version = 2;

  static Anime updateAnime(Anime anime) {
    _box.put(anime.id, anime);
    BackupService.uploadOneToDB(anime);
    return anime;
  }

  static Anime getAnimeById(int id) {
    return _box.get(id);
  }

  static List<Anime> searchFavorites(String query) {
    return _box.values
        .where((anime) => anime.name.contains(query ?? '') && anime.favorite)
        .toList();
  }

  static List<Anime> searchByWatchingState(String query, WatchingState state) {
    return _box.values
        .where((anime) =>
            anime.name.contains(query ?? '') && anime.watchingState == state)
        .toList();
  }

  static Future upgradeAnimeVersion(Anime anime) async {
    final newData = await RequestsService.getAnime(anime);
    final mergedAnimeMap = {
      ...newData.toMap()..removeWhere((_, value) => value == null),
      ...anime.toMap(true)..removeWhere((_, value) => value == null),
    };
    final finalAnime = Anime.fromMap(mergedAnimeMap);

    Hive.box<Anime>('animes').put(finalAnime.id, finalAnime);
  }
}
