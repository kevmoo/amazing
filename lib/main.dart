import 'dart:math';
import 'dart:ui';

import 'package:amazing/model/card.dart';
import 'package:flutter/material.dart';

import 'model/tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Material(
        child: GridView.builder(
          padding: EdgeInsets.all(20),
          itemCount: 49,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (ctx, index) {
            return TileView();
          },
        ),
      ),
    );
  }
}

class TileView extends StatelessWidget {
  final CardTile tile = randomTile();
  final Rotation rotation = randomRotation();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _TilePainter(tile, rotation));
}

class _TilePainter extends CustomPainter {
  final Tile _tile;
  final Rotation _rotation;

  _TilePainter(this._tile, this._rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final smallestDimension =
        size.width < size.height ? size.width : size.height;

    canvas.scale(smallestDimension / 4, smallestDimension / 4);

    canvas.translate(2, 2);
    canvas.rotate(_radiansFromRotation(_rotation));
    canvas.translate(-2, -2);

    final tile = _tile;
    canvas.drawPath(
      _pathFromPathType(tile.pathType),
      _pathPaint,
    );

    if (tile is CardTile) {
      final builder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 1.5,
      ));
      builder.addText(cardValues[tile.cardId]);

      final paragraph = builder.build()..layout(ParagraphConstraints(width: 4));

      canvas.drawParagraph(paragraph, Offset(0, 0.5));
    }

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, 4, 4, Radius.circular(0.8)),
      Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.1,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Path _pathFromPathType(PathType pathType) {
  switch (pathType) {
    case PathType.tee:
      return _teePath;
    case PathType.corner:
      return _cornerPath;
    case PathType.straight:
      return _straightPath;
    default:
      throw UnimplementedError();
  }
}

double _radiansFromRotation(Rotation r) {
  switch (r) {
    case Rotation.d0:
      return 0;
    case Rotation.d90:
      return pi * 0.5;
    case Rotation.d180:
      return pi;
    case Rotation.d270:
      return pi * 1.5;
    default:
      throw UnimplementedError();
  }
}

final _pathPaint = Paint()..color = Colors.brown.shade200;

final _straightPath = Path()
  ..moveTo(0, 1)
  ..lineTo(4, 1)
  ..lineTo(4, 3)
  ..lineTo(0, 3)
  ..close();

final _teePath = Path()
  ..moveTo(0, 1)
  ..lineTo(1, 1)
  ..lineTo(1, 0)
  ..lineTo(3, 0)
  ..lineTo(3, 1)
  ..lineTo(4, 1)
  ..lineTo(4, 3)
  ..lineTo(0, 3)
  ..close();

final _cornerPath = Path()
  ..moveTo(1, 0)
  ..lineTo(3, 0)
  ..lineTo(3, 1)
  ..lineTo(4, 1)
  ..lineTo(4, 3)
  ..lineTo(1, 3)
  ..close();
