import 'package:flutter/material.dart';
import 'package:axplay/utils/responsive.dart';

class NeumorphicContainer extends StatelessWidget {
  final List<Color>? colors;
  final Offset? startOffset;
  final Offset? endOffset;
  final double? blurRadius;
  final double? spreadRadius;
  final double? width;
  final List<double>? stops;
  final double? height;
  final BoxShape? shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  const NeumorphicContainer({
    super.key,
    this.colors,
    this.startOffset,
    this.endOffset,
    this.blurRadius = 10,
    this.spreadRadius = 1,
    this.child,
    this.margin,
    this.stops,
    this.padding,
    this.width,
    this.height,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = colors?.first ?? Color(0xFFF0F0F3);
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape ?? BoxShape.rectangle,
        borderRadius:
            shape != BoxShape.circle ? BorderRadius.circular(20.s) : null,
        color: baseColor,
        boxShadow: [
          // Light shadow (highlight)
          BoxShadow(
            color: colors?.first ?? Colors.white,
            offset: startOffset ?? Offset(-5.s, -5.s),
            blurRadius: blurRadius!,
            spreadRadius: spreadRadius!,
          ),
          // Darker shadow (depth)
          BoxShadow(
            color: colors?.last ?? const Color.fromRGBO(158, 158, 158, 0.3),
            offset: endOffset ?? Offset(5.s, 5.s),
            blurRadius: blurRadius!,
            spreadRadius: spreadRadius!,
          ),
        ],
        gradient: LinearGradient(
          stops: stops,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? [Color(0xFFF0F0F3), Color(0xFFE0E0E5)],
        ),
      ),
      child: child,
    );
  }
}
