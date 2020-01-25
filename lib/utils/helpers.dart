import 'package:animu/services/anime_database.dart';
import 'package:animu/utils/models.dart';

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

String formatDay(DateTime date) {
  final weekdays = {
    DateTime.sunday: 'domingo',
    DateTime.monday: 'lunes',
    DateTime.tuesday: 'martes',
    DateTime.wednesday: 'miércoles',
    DateTime.thursday: 'jueves',
    DateTime.friday: 'viernes',
    DateTime.saturday: 'sábado',
  };
  final months = {
    DateTime.january: 'enero',
    DateTime.february: 'febrero',
    DateTime.march: 'marzo',
    DateTime.april: 'abril',
    DateTime.may: 'mayo',
    DateTime.june: 'junio',
    DateTime.july: 'julio',
    DateTime.august: 'agosto',
    DateTime.september: 'septiembre',
    DateTime.october: 'octubre',
    DateTime.november: 'noviembre',
    DateTime.december: 'diciembre',
  };

  return weekdays[date.weekday] +
      ' ' +
      date.day.toString() +
      ' de ' +
      months[date.month] +
      ' del ' +
      date.year.toString();
}

dynamic stringToKey(String string, Map<dynamic, String> map) =>
    map.entries.firstWhere((x) => x.value == string).key;

Anime seenUnseen(Anime anime, Episode episode) {
  if (anime.episodesSeen == null) anime.episodesSeen = [];
  if (anime.episodesSeen.contains(episode.n))
    anime.episodesSeen.remove(episode.n);
  else
    anime.episodesSeen.add(episode.n);
  AnimeDatabaseService.updateAnime(anime);
  return anime;
}
