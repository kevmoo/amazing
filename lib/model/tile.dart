/*
34 moving tiles
  - 12 straight
  - 10 corner
  - 6 corner w/ card
  - 6 "T" w/ card
12 fixed "T" tiles w/ card
4 corners

50 tiles: 49 on the board + 1 floating
 */

class Tile {
  final PathType pathType;

  Tile(this.pathType);
}

class StartTile extends Tile {
  final Player player;

  StartTile(this.player) : super(PathType.corner);
}

class CardTile extends Tile {
  static const tileCount = 24;

  final int cardId;

  CardTile(PathType pathType, this.cardId)
      : assert(cardId >= 0),
        assert(cardId < tileCount),
        super(pathType);
}

enum PathType {
  straight,
  corner,
  tee,
}

enum Player {
  red,
  green,
  blue,
  yellow,
}

enum Rotation {
  d0,
  d90,
  d180,
  d270,
}
