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
