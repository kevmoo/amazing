// 9x9 grid
// 7x7 playable area
// + 1 on each side for sliding in!

import 'dart:math' show Random;

import '../util/array_2d.dart';
import 'tile.dart';

const boardSize = 7;

final _rnd = Random();

class OrientedTile {
  final Tile tile;
  final Rotation rotation;
  final bool fixed;

  OrientedTile(
    this.tile, {
    Rotation rotation,
    bool fixed,
  })  : rotation =
            rotation ?? Rotation.values[_rnd.nextInt(Rotation.values.length)],
        fixed = fixed ?? (rotation != null);
}

Board randomBoard() {
  var cardIndex = 0;

  final movingTiles = <OrientedTile>[
    // moving tiles
    for (var i = 0; i < 12; i++) OrientedTile(Tile(PathType.straight)),
    for (var i = 0; i < 10; i++) OrientedTile(Tile(PathType.corner)),

    for (var i = 0; i < 6; i++)
      OrientedTile(
        CardTile(PathType.corner, cardIndex++),
      ),
    for (var i = 0; i < 6; i++)
      OrientedTile(
        CardTile(PathType.tee, cardIndex++),
      ),
  ]..shuffle(_rnd);

  final fixedTiles = [
    // Row 1
    OrientedTile(
      StartTile(Player.blue),
      rotation: Rotation.d90,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d180,
    ),
    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d180,
    ),
    movingTiles.removeLast(),

    OrientedTile(
      StartTile(Player.red),
      rotation: Rotation.d180,
    ),

    // Row 2
    for (var i = 0; i < 7; i++) movingTiles.removeLast(),

    // Row 3
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d90,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d180,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d270,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d270,
    ),

    // Row 4
    for (var i = 0; i < 7; i++) movingTiles.removeLast(),

    // Row 5
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d90,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d90,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d0,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d270,
    ),

    // Row 6
    for (var i = 0; i < 7; i++) movingTiles.removeLast(),

    // Row 7

    OrientedTile(
      StartTile(Player.yellow),
      rotation: Rotation.d0,
    ),

    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d0,
    ),
    movingTiles.removeLast(),
    OrientedTile(
      CardTile(PathType.tee, cardIndex++),
      rotation: Rotation.d0,
    ),
    movingTiles.removeLast(),

    OrientedTile(
      StartTile(Player.green),
      rotation: Rotation.d270,
    ),
  ];

  assert(movingTiles.length == 1);
  assert(fixedTiles.length == 49);

  return Board(fixedTiles, movingTiles.single.tile);
}

class Board {
  final Tile remainingTile;
  final Array2d<OrientedTile> array;

  Board(List<OrientedTile> boardTiles, this.remainingTile)
      : assert(boardTiles.length == boardSize * boardSize),
        array = Array2d.readonlyFrom(boardSize, boardTiles) {
    assert(_validBoard(array));
  }
}

bool _validBoard(Iterable<OrientedTile> values) {
  final cards = values.whereType<CardTile>().map((e) => e.cardId).toList();

  // true if there are no duplicate!
  return cards.length == cards.toSet().length;
}
