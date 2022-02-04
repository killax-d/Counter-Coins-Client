// ignore_for_file: constant_identifier_names

enum CoinFaceType {
  FRONT,
  BACK
}

enum CoinType {
  ONE_CENT,
  TWO_CENTS,
  FIVE_CENTS,
  TEN_CENTS,
  TWENTY_CENTS,
  FIFTY_CENTS,
  ONE_EURO,
  TWO_EUROS,
  NOT_A_COIN
}

CoinType? getCoinTypeFromId(String id) {
  switch (id.split("_")[0]) {
    case "1c":
      return CoinType.ONE_CENT;
    case "2c":
      return CoinType.TWO_CENTS;
    case "5c":
      return CoinType.FIVE_CENTS;
    case "10c":
      return CoinType.TEN_CENTS;
    case "20c":
      return CoinType.TWENTY_CENTS;
    case "50c":
      return CoinType.FIFTY_CENTS;
    case "1e":
      return CoinType.ONE_EURO;
    case "2e":
      return CoinType.TWO_EUROS;
    default:
      return CoinType.NOT_A_COIN;
  }
}

// Default 'front'
CoinFaceType getCoinFaceTypeFromString(String face) {
  switch (face) {
    case "front":
      return CoinFaceType.FRONT;
    case "back":
      return CoinFaceType.BACK;
    default:
      return CoinFaceType.FRONT;
  }
}

class CoinFace {
  String label;

  CoinFace({required this.label});
}

class Coin {

  static final Map<CoinFaceType, CoinFace> _typeFace = {
    CoinFaceType.FRONT: CoinFace(label: 'front'),
    CoinFaceType.BACK: CoinFace(label: 'back'),
  };

  static CoinFace? getFace(CoinFaceType faceType) {
    return _typeFace[faceType];
  }

  static final Map<CoinType, Coin> _typeCoin = {
    CoinType.ONE_CENT: Coin(label: '1 centime', id: '1c', value: 1),
    CoinType.TWO_CENTS: Coin(label: '2 centimes', id: '2c', value: 2),
    CoinType.FIVE_CENTS: Coin(label: '5 centimes', id: '5c', value: 5),
    CoinType.TEN_CENTS: Coin(label: '10 centimes', id: '10c', value: 10),
    CoinType.TWENTY_CENTS: Coin(label: '20 centimes', id: '20c', value: 20),
    CoinType.FIFTY_CENTS: Coin(label: '50 centimes', id: '50c', value: 50),
    CoinType.ONE_EURO: Coin(label: '1 euro', id: '1e', value: 100),
    CoinType.TWO_EUROS: Coin(label: '2 euros', id: '2e', value: 200),
    CoinType.NOT_A_COIN: Coin(label: '', id: '0', value: 0)
  };

  static Coin? getCoin(CoinType type) {
    return _typeCoin[type];
  }

  static List<CoinFace> get faces {
    List<CoinFace> faces = _typeFace.values.toList();
    return faces;
  }

  static List<Coin> get coins {
    List<Coin> coins = _typeCoin.values.toList();
    coins.removeLast();
    return coins;
  }

  String label;
  String id;
  int value;

  Coin({required this.label, required this.id, required this.value});

  @override
  String toString() {
    return 'Coin{label: $label, value: $value}';
  }
}