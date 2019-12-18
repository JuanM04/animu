import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CastPlayerControls extends StatefulWidget {
  final dynamic data;
  const CastPlayerControls({Key key, this.data}) : super(key: key);

  @override
  _CastPlayerControlsState createState() => _CastPlayerControlsState();
}

class _CastPlayerControlsState extends State<CastPlayerControls> {
  bool isPlaying = false;
  bool sliding = false;
  Duration time = Duration.zero;
  Duration length = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final vlc = Provider.of<VLCNotifier>(context);
    if (!sliding) {
      isPlaying = widget.data['state'] == 'playing';
      time = Duration(seconds: widget.data['time']);
      length = Duration(seconds: widget.data['length']);
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => vlc.send('seek', val: '-10s'),
              child: Icon(Icons.replay_10, size: 50),
            ),
            GestureDetector(
              onTap: () {
                vlc.send('pl_pause');
                setState(() => isPlaying = !isPlaying);
              },
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 100,
              ),
            ),
            GestureDetector(
              onTap: () => vlc.send('seek', val: '+10s'),
              child: Icon(Icons.forward_10, size: 50),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(formatDuration(time)),
              Text(formatDuration(length)),
            ],
          ),
        ),
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          child: Slider(
            value: time.inSeconds.toDouble(),
            min: 0,
            max: length.inSeconds.toDouble(),
            activeColor: Theme.of(context).primaryColor,
            onChangeStart: (seconds) => setState(() => sliding = true),
            onChanged: (seconds) =>
                setState(() => time = Duration(seconds: seconds.round())),
            onChangeEnd: (seconds) => setState(() {
              sliding = false;
              vlc.send('seek', val: seconds.round().toString());
            }),
          ),
        ),
      ],
    );
  }
}
