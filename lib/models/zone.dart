import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_projet/models/coin.dart';

/// Example of data received from the API
/// {
///     "id": 0,
///     "zone": {
///       "height": 82,
///       "width": 82,
///       "x": 306,
///       "y": 442
///     },
///     "coin": "1e",
///     "old_coin": "2e", // optional
///     "confidence": 0.0,
///     "old_confidence": 99.91416931152344 // optional
///   }

class ReportZone {
  String reportId;
  int id;
  Rectangle rect;
  Coin? coin;
  Coin? oldCoin;
  double confidence;
  double? oldConfidence;
  CoinFace? face;
  CoinFace? oldFace;
  Image? image;
  Uint8List? imageBytes;

  ReportZone(this.reportId, this.id, this.rect, this.oldCoin, this.coin, this.oldConfidence, this.confidence, this.oldFace, this.face, [this.imageBytes]);

  factory ReportZone.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> zone;
    if (json['zone'].runtimeType == String) {zone = jsonDecode(json['zone']);}
    else {zone = json['zone'];}

    String oldCoin = "";
    double oldConfidence = 0.0;
    if (json.containsKey('old_coin') && json['old_coin'].runtimeType == String) {
      oldCoin = json['old_coin'];
      oldConfidence = json['old_confidence'];
    }
    
    return ReportZone(
      json['report_id'],
      json['id'],
      Rectangle(zone['x'], zone['y'], zone['width'], zone['height']),
      oldCoin.isEmpty ? null : Coin.getCoin(getCoinTypeFromId(oldCoin)!),
      (json['coin'] != null ? Coin.getCoin(getCoinTypeFromId(json['coin'])!) : null),
      oldConfidence,
      json['confidence'],
      oldCoin.isEmpty ? null : Coin.getFace(getCoinFaceTypeFromString(oldCoin.split('_')[1])),
      Coin.getFace(getCoinFaceTypeFromString(json['coin'].split('_')[1])),
      json['image'] != null ? Uint8List.fromList(json['image']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'report_id': reportId,
      'id': id,
      'zone': {
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height
      },
      'coin': "${coin?.id}_${face!.label}",
      'old_coin': "${oldCoin?.id}_${oldFace!.label}",
      'confidence': confidence,
      'old_confidence': oldConfidence,
      'image': imageBytes != null ? imageBytes! : null,
    };
  }

  void setImage(Image image) { this.image = image; }

  void setCoin(Coin coin) {
    if (oldCoin == null) {
      oldCoin = this.coin;
      oldConfidence = confidence;
      if (coin.id != this.coin!.id) {
        confidence = 0.0;
      }
    } else if (oldCoin != null && coin.id == oldCoin?.id) {
      confidence = oldConfidence!;
    } else {
      confidence = 0.0;
    }
    this.coin = coin;
  }

  void setFace(CoinFace face) {
    this.face = face;
  }

  @override
  String toString() {
    return 'ReportZone{id: $id, rect: $rect, coin: $coin, confidence: $confidence}';
  }
  
  clone () {
    return ReportZone(reportId, id, Rectangle(rect.left, rect.top, rect.width, rect.height), oldCoin, coin, oldConfidence, confidence, oldFace, face);
  }
}