import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';

class DragDropState {
  final List<CustomDragTargetDetails> availableItems;
  final List<CustomDragTargetDetails> selectedItems;

  DragDropState({
    required this.availableItems,
    required this.selectedItems,
  });

  DragDropState copyWith({
    List<CustomDragTargetDetails>? availableItems,
    List<CustomDragTargetDetails>? selectedItems,
  }) {
    return DragDropState(
      availableItems: availableItems ?? this.availableItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
