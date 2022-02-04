import 'dart:convert';

/// Example of data received from the API
/// {
///  "id": "86052620-02d1-49c3-a318-91c57d9f934c",
///  "datetime": "2021-12-02T19:17:19.282281+01:00",
///  "pictures_count": { ... }
/// }

class Model {
  String id;
  DateTime datetime;
  Map<String, dynamic> picturesCount;

  Model(this.id, this.datetime, this.picturesCount);

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      json['id'],
      DateTime.parse(json['datetime']),
      json['pictures_count'].runtimeType == String ? jsonDecode(json['pictures_count']) : json['pictures_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'pictures_count': picturesCount
    };
  }

  int get totalPictures {
    return picturesCount.values.reduce((a, b) => a + b);
  }

  @override
  String toString() {
    return 'Report{id: $id, datetime: $datetime, picturesCount: $picturesCount}';
  }

}