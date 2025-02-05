import 'package:flutter/material.dart';

class FlexibleWrapWidget extends StatelessWidget {
  const FlexibleWrapWidget({
    super.key,
    required this.children,
    required this.itemWidth,
    this.textDirection,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 4.0,
    this.antherChildren = const [],
    this.noFlexibleWidget = const [],
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior,
    this.fillEntireWidth = false,
  });

  final List<Widget> children;
  final List<Widget> antherChildren;
  final List<Widget> noFlexibleWidget;
  final double itemWidth;
  final bool fillEntireWidth;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final WrapAlignment runAlignment;
  final double runSpacing = 0.0;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemActualWidth = itemWidth;
        double extraWidth = 0.0;

        if (fillEntireWidth && constraints.maxWidth.isFinite) {
          // Fill entire width, dividing by the number of items
          final totalSpacing = spacing * (children.length - 1);
          itemActualWidth = (constraints.maxWidth - totalSpacing) / children.length;
        } else if (constraints.maxWidth.isFinite) {
          // Distribute extra width proportionally when fillEntireWidth is false
          final double widthWithSpacing = itemWidth + spacing;
          final int itemsPerRow = (constraints.maxWidth / widthWithSpacing).floor();
          final double remainder = constraints.maxWidth.remainder(widthWithSpacing);

          if (itemsPerRow > 0) {
            extraWidth = remainder / itemsPerRow;
          }
          itemActualWidth = itemWidth + extraWidth;
        }

        // Construct final children list with flexibility for each item
        final List<Widget> finalChildren = [
          // Only add the children if they are not empty
          if (children.isNotEmpty)
            ...children.take(children.length - 1).map((child) => SizedBox(width: itemActualWidth, child: child)),
          // Add additional children and noFlexibleWidgets
          if (antherChildren.isNotEmpty)
            ...antherChildren.map((child) => SizedBox(width: itemActualWidth, child: child)),
          // Only add the last child of the 'children' list if it exists
          if (children.isNotEmpty)
            SizedBox(width: itemActualWidth, child: children.last),
          // Add non-flexible widgets if they exist
          if (noFlexibleWidget.isNotEmpty)
            ...noFlexibleWidget.map((child) => child),
        ];

        return Wrap(
          direction: direction,
          textDirection: textDirection,
          alignment: alignment,
          spacing: spacing,
          runSpacing: spacing,
          crossAxisAlignment: crossAxisAlignment,
          verticalDirection: verticalDirection,
          runAlignment: runAlignment,
          children: finalChildren,
        );
      },
    );
  }
}
