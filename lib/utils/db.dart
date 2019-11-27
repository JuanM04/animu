import 'package:animu/utils/classes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnimeDatabase {
  Database db;

  Future<void> _init() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'anime.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE animes(id INTEGER PRIMARY KEY, name TEXT, slug TEXT, favorite INTEGER, episodes_seen TEXT)'),
      version: 1,
    );
  }

  Future<void> _close() async => await db.close();

  Future<Anime> _insert(Anime anime) async {
    await db.insert(
      'animes',
      anime.toDBMap(),
    );

    return anime;
  }

  Future<Anime> _update(Anime anime) async {
    await db.update(
      'animes',
      anime.toDBMap(),
      where: 'id = ?',
      whereArgs: [anime.id],
    );

    return anime;
  }

  Future<List> _getById(int id) async {
    return await db.query(
      'animes',
      where: 'id = ?',
      limit: 1,
      whereArgs: [id],
    );
  }

  Future<Anime> updateAnime(Anime anime) async {
    await _init();

    bool exists = (await _getById(anime.id)).length == 1;
    if (exists)
      _update(anime);
    else
      _insert(anime);

    await _close();
    return anime;
  }

  Future<dynamic> getAnimeById(int id) async {
    await _init();
    var rawRes = await _getById(id);
    await _close();

    return rawRes.isNotEmpty ? Anime.fromDBMap(rawRes[0]) : null;
  }

  Future<List<Anime>> getFavorites() async {
    await _init();
    var res = await db.query(
      'animes',
      where: 'favorite = 1',
      orderBy: 'name',
    );
    await _close();

    return List.generate(
      res.length,
      (i) => Anime.fromDBMap(res[i]),
    );
  }
}
