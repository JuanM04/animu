import 'dart:convert';
import 'dart:typed_data';

class Episode {
  final int id;
  final int n;
  final Uint8List thumbnail;

  Episode({this.id, this.n, this.thumbnail});

  factory Episode.fromMap(Map<String, dynamic> map) {
    return Episode(
      id: map['id'],
      n: map['n'],
      thumbnail:
          map['thumbnail'] == null ? null : base64Decode(map['thumbnail']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'n': n,
      'thumbnail': thumbnail == null ? null : base64Encode(thumbnail),
    };
  }
}
