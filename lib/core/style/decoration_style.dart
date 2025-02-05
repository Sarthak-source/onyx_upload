import 'package:flutter/material.dart';

class AppDecorations {
  static BoxDecoration boxDecoration(
          {Color? color,
          double? radius,
          BoxShape? shape,
          ImageProvider<Object>? image,
          Gradient? gradient,
          BorderRadiusGeometry? borderRadius,
          BoxBorder? border}) =>
      BoxDecoration(
        color: color,
        border: border,
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.rectangle,
        image: image == null ? null : DecorationImage(image: image),
        gradient: gradient,
      );

  static BoxDecoration boxDecorationWithShape(
          {Color? color,
          double? radius,
          BoxShape? shape,
          ImageProvider<Object>? image,
          Gradient? gradient,
          BorderRadiusGeometry? borderRadius,
          BoxBorder? border}) =>
      BoxDecoration(
        color: color,
        border: border,
        borderRadius: borderRadius,
        shape: shape ?? BoxShape.rectangle,
        image: image == null ? null : DecorationImage(image: image),
        gradient: gradient,
      );
}
