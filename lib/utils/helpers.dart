import 'package:dio/dio.dart';

Future<dynamic> getJSONFromServer(
  String endpoint,
  Map<String, String> query,
) async {
  Response response = await new Dio().get(
    'https://animu.juanm04.com/api' + endpoint,
    queryParameters: query,
  );
  return response.data;
}

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
