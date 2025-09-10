import 'dart:ui';

class CustomDragTargetDetails {
  final String id; // Unique identifier for the item
  final String data;
  final Offset offset;

  CustomDragTargetDetails(
      {required this.id, required this.data, required this.offset});
}