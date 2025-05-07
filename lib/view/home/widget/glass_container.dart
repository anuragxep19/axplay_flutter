//import 'dart:ui' show Color, ImageFilter;

import 'package:flutter/material.dart';
import 'package:axplay/utils/responsive.dart';

class GlassWidget extends StatelessWidget {
  final Widget? child;
  final double opacity;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const GlassWidget({
    super.key,
    this.child,
    this.opacity = 0.2,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      // child: BackdropFilter(
      //filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, opacity),
          borderRadius: borderRadius,
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.3),
            width: 1.5.s,
          ),
        ),
        child: child,
        //     ),
      ),
    );
  }
}
