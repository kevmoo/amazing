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

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _TilePainter(tile));
}

final _grayPaint = Paint()..color = Colors.grey;

class _TilePainter extends CustomPainter {
  final Tile _tile;

  _TilePainter(this._tile);

  @override
  void paint(Canvas canvas, Size size) {
    final smallestDimension =
        size.width < size.height ? size.width : size.height;

    canvas.scale(smallestDimension / 4, smallestDimension / 4);

    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, 4, 4, Radius.circular(1)),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );

    canvas.drawRect(
      Rect.fromLTWH(1, 1, 3, 2),
      _grayPaint,
    );

    switch (_tile.pathType) {
      case PathType.straight:
        canvas.drawRect(
          Rect.fromLTWH(0, 1, 1, 2),
          _grayPaint,
        );
        break;
      case PathType.tee:
        canvas.drawRect(
          Rect.fromLTWH(0, 1, 1, 2),
          _grayPaint,
        );
        canvas.drawRect(
          Rect.fromLTWH(1, 0, 2, 1),
          _grayPaint,
        );
        break;
      case PathType.corner:
        canvas.drawRect(
          Rect.fromLTWH(1, 0, 2, 1),
          _grayPaint,
        );
        break;
    }

    final tile = _tile;
    if (tile is CardTile) {
      final builder = ParagraphBuilder(ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 1.5,
      ));
      builder.addText(cardValues[tile.cardId]);

      final paragraph = builder.build()..layout(ParagraphConstraints(width: 4));

      canvas.drawParagraph(paragraph, Offset(0, 0.5));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
