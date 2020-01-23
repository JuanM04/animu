import 'package:animu/services/backup.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/utils/watching_states.dart';
import 'package:hive/hive.dart';

class AnimeDatabaseService {
  static final _box = Hive.box<Anime>('animes');

  static Anime updateAnime(Anime anime) {
    _box.put(anime.id, anime);
    BackupService.uploadToDB();
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
}
