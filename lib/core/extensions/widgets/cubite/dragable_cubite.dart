import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/cubite/dragable_state.dart';
import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';


class DragDropCubit extends Cubit<DragDropState> {
  DragDropCubit()
      : super(DragDropState(
          availableItems: [
            CustomDragTargetDetails(
                id: '1', data: 'invoice_amount', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '2', data: 'currency_unit', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '3', data: 'promotion_groups', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '4', data: 'payment_method', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '5', data: 'store', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '6', data: 'store_groups', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '7', data: 'store_region_number', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '8', data: 'customer_type', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '9', data: 'customer_group', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '10', data: 'customer_degree', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '11', data: 'customer_activity', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '12',
                data: 'customer_classification',
                offset: Offset.zero),
            CustomDragTargetDetails(
                id: '13', data: 'customer_number', offset: Offset.zero),
            CustomDragTargetDetails(
                id: '14', data: 'my_customers', offset: Offset.zero),
            // Add more items here...
          ],
          selectedItems: [],
        ));

  Map<int, CustomDragTargetDetails> indexMemory() {
    final indexMemory =
        List<CustomDragTargetDetails>.from(state.availableItems).asMap();
    // Use indexMemory as needed
    return indexMemory;
  }

  void moveItemToSelected(CustomDragTargetDetails item) {
    // Check if the item is already in the selected list
    if (!state.selectedItems
        .any((selectedItem) => selectedItem.data == item.data)) {
      final newAvailable =
          List<CustomDragTargetDetails>.from(state.availableItems)
            ..remove(item);
      final newSelected =
          List<CustomDragTargetDetails>.from(state.selectedItems)..add(item);

      emit(state.copyWith(
          availableItems: newAvailable, selectedItems: newSelected));
    }
  }

  void moveItemToAvailable(CustomDragTargetDetails item) {
    if (!state.availableItems
        .any((availableItem) => availableItem.data == item.data)) {
      final newSelected =
          List<CustomDragTargetDetails>.from(state.selectedItems)..remove(item);

      final newAvailable =
          List<CustomDragTargetDetails>.from(state.availableItems)..add(item);

      newAvailable.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

      emit(state.copyWith(
          availableItems: newAvailable, selectedItems: newSelected));
    }
  }

  void reorderAvailableItems(int oldIndex, int newIndex) {
    final newAvailable =
        List<CustomDragTargetDetails>.from(state.availableItems);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = newAvailable.removeAt(oldIndex);
    newAvailable.insert(newIndex, item);

    emit(state.copyWith(availableItems: newAvailable));
  }

  void reorderSelectedItems(int oldIndex, int newIndex) {
    final newSelected = List<CustomDragTargetDetails>.from(state.selectedItems);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = newSelected.removeAt(oldIndex);
    newSelected.insert(newIndex, item);

    emit(state.copyWith(selectedItems: newSelected));
  }

  void moveAllToSelected() {
    final newSelected = List<CustomDragTargetDetails>.from(state.selectedItems)
      ..addAll(state.availableItems);

    emit(state.copyWith(availableItems: [], selectedItems: newSelected));
  }

  void moveAllToAvailable() {
    final newAvailable =
        List<CustomDragTargetDetails>.from(state.availableItems)
          ..addAll(state.selectedItems);

    emit(state.copyWith(availableItems: newAvailable, selectedItems: []));
  }

  void clearSelectedItems() {
    final newAvailable =
        List<CustomDragTargetDetails>.from(state.availableItems)
          ..addAll(state.selectedItems);

    emit(state.copyWith(availableItems: newAvailable, selectedItems: []));
  }
}