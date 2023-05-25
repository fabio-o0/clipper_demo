import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipper Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Clipper Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: CircleClipper(),
              child: const SizedBox(
                height: 200,
                width: 200,
                child: UiKitView(
                  viewType: 'red_view',
                  layoutDirection: TextDirection.ltr,
                  creationParams: {},
                  creationParamsCodec: StandardMessageCodec(),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ClipPath(
              clipper: StarClipper(),
              child: const SizedBox(
                height: 200,
                width: 200,
                child: UiKitView(
                  viewType: 'blue_view',
                  layoutDirection: TextDirection.ltr,
                  creationParams: {},
                  creationParamsCodec: StandardMessageCodec(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class StarClipper extends CustomClipper<Path> {
  final int numPoints;
  final double innerRadius;
  final double outerRadius;

  StarClipper({
    this.numPoints = 5,
    this.innerRadius = 50.0,
    this.outerRadius = 100.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double delta = 2 * pi / numPoints;

    double angle = -pi / 2;
    path.moveTo(cx + outerRadius * cos(angle), cy + outerRadius * sin(angle));

    for (int i = 1; i <= numPoints; i++) {
      angle += delta;
      path.lineTo(
        cx + innerRadius * cos(angle),
        cy + innerRadius * sin(angle),
      );
      angle += delta;
      path.lineTo(
        cx + outerRadius * cos(angle),
        cy + outerRadius * sin(angle),
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(StarClipper oldClipper) {
    return numPoints != oldClipper.numPoints ||
        innerRadius != oldClipper.innerRadius ||
        outerRadius != oldClipper.outerRadius;
  }
}
