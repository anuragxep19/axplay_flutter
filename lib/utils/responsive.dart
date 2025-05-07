import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScreenScaler {
  static late double scale;

  static const Size baseSize = Size(390, 844); // iPhone 13 dimensions

  static void init(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final double shortSide = math.min(screenSize.width, screenSize.height);
    final double longSide = math.max(screenSize.width, screenSize.height);
    final double screenDiagonal = math.sqrt(
      shortSide * shortSide + longSide * longSide,
    );

    final double baseDiagonal = math.sqrt(
      baseSize.width * baseSize.width + baseSize.height * baseSize.height,
    );

    scale = screenDiagonal / baseDiagonal;
  }
}

extension ResponsiveSize on num {
  double get s => this * ScreenScaler.scale;
}

extension Mode on BuildContext {
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}
