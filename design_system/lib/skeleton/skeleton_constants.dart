import 'package:flutter/material.dart';

class SkeletonConstants {
  const SkeletonConstants._();

  static LinearGradient shimmerGradient({required double slidePercent}) =>
      LinearGradient(
        colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
        stops: [0.1, 0.3, 0.4],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
        transform: _SlidingGradientTransform(slidePercent: slidePercent),
      );


}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
