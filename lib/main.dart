import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rectangle with AOI')),
        body: const Center(
          child: AoiRect(
            width: 3840,
            height: 2160,
            offsetX: 500,
            offsetY: 700,
            aoiWidth: 1920,
            aoiHeight: 1080,
          ),
        ),
      ),
    );
  }
}

class AoiRect extends StatelessWidget {
  final double width;
  final double height;
  final double offsetX;
  final double offsetY;
  final double aoiWidth;
  final double aoiHeight;

  const AoiRect({
    super.key,
    required this.width,
    required this.height,
    required this.offsetX,
    required this.offsetY,
    required this.aoiWidth,
    required this.aoiHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / width;
        final scaleY = constraints.maxHeight / height;
        final scale = scaleX < scaleY ? scaleX : scaleY;

        final rectWidth = width * scale;
        final rectHeight = height * scale;
        final aoiLeft = offsetX * scale;
        final aoiTop = offsetY * scale;
        final aoiRectWidth = aoiWidth * scale;
        final aoiRectHeight = aoiHeight * scale;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: rectWidth,
              height: rectHeight,
              color: Colors.blue.withOpacity(0.5),
            ),
            Positioned(
              left: aoiLeft,
              top: aoiTop,
              child: Container(
                width: aoiRectWidth,
                height: aoiRectHeight,
                color: Colors.amber.withOpacity(0.5),
              ),
            ),
          ],
        );
      },
    );
  }
}
