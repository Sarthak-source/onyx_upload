import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  // Constructor and initial state
  FileUploadCubit()
      : super(FileUploadState(selectedItems: [
          CustomDragTargetDetails(id: '1', data: "مبلغ الفاتورة", offset: Offset.zero),
          CustomDragTargetDetails(id: '2', data: "الوحدة المالية", offset: Offset.zero),
          CustomDragTargetDetails(id: '3', data: "مجموعات العروض الترويجية", offset: Offset.zero),
          CustomDragTargetDetails(id: '4', data: "طريقة الدفع", offset: Offset.zero),
          CustomDragTargetDetails(id: '5', data: "المخزن", offset: Offset.zero),
          CustomDragTargetDetails(id: '6', data: "مجموعات المخازن", offset: Offset.zero),
          CustomDragTargetDetails(id: '7', data: "رقم المنطقة المخزن", offset: Offset.zero),
          CustomDragTargetDetails(id: '8', data: "نوع العميل", offset: Offset.zero),
          CustomDragTargetDetails(id: '9', data: "مجموعة العميل", offset: Offset.zero),
          CustomDragTargetDetails(id: '10', data: "درجة العميل", offset: Offset.zero),
          CustomDragTargetDetails(id: '12', data: "رقم العميل", offset: Offset.zero),
          CustomDragTargetDetails(id: '13', data: "نشاط العميل", offset: Offset.zero),
        ]));

  Map<int, String?> selectedDropdownPerRow = {};

  // ==================== File Processing Methods ====================

  /// Handles picking and processing an Excel or CSV file.
  Future<void> pickAndProcessExcelFile() async {
    emit(state.copyWith(isLoading: true));
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null) {
          if (file.extension == 'csv') {
            _processCSVFile(bytes);
          } else if (file.extension == 'xlsx' || file.extension == 'xls') {
            _processExcelFile(bytes);
          }
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } on PlatformException catch (e) {
      log("Unsupported operation: ${e.toString()}");
      emit(state.copyWith(isLoading: false, errorMessage: "Unsupported operation: ${e.message}"));
    } catch (e) {
      log("Error picking file: ${e.toString()}");
      emit(state.copyWith(isLoading: false, errorMessage: "Error picking file: ${e.toString()}"));
    }
  }

  /// Processes a CSV file from bytes.
  void _processCSVFile(Uint8List bytes) {
    try {
      String csvString = utf8.decode(bytes);
      List<List<dynamic>> fields = const CsvToListConverter().convert(csvString);

      emit(state.copyWith(
        tableData: fields,
        headers: fields.isNotEmpty ? fields.first.map((e) => e.toString()).toList() : [],
        showTable: true,
        isLoading: false,
        selectedColumns: [],
      ));
    } catch (e) {
      log("Error processing CSV: $e");
      emit(state.copyWith(errorMessage: 'Failed to process CSV file', isLoading: false));
    }
  }

  /// Processes an Excel file from bytes.
  void _processExcelFile(Uint8List bytes) {
    try {
      var excel = Excel.decodeBytes(bytes);
      String firstSheetName = excel.tables.keys.first;
      var sheet = excel.tables[firstSheetName];

      List<List<dynamic>> rows = [];
      if (sheet != null) {
        for (var row in sheet.rows) {
          rows.add(row.map((cell) => cell?.value ?? '').toList());
        }
      }

      emit(state.copyWith(
        tableData: rows,
        headers: rows.isNotEmpty ? rows.first.map((e) => e.toString()).toList() : [],
        showTable: true,
        isLoading: false,
        selectedColumns: [],
      ));
    } catch (e) {
      log("Error processing Excel: $e");
      emit(state.copyWith(errorMessage: 'Failed to process Excel file', isLoading: false));
    }
  }

  // ==================== State Management Methods ====================

  /// Toggles the visibility of the message banner.
  void showBanner() {
    emit(state.copyWith(showMessage: !state.showMessage));
  }

  /// Updates the text field value in the state.
  void textShow(String? val) {
    emit(state.copyWith(customTextFildTable: val));
  }

  /// Updates the dropdown table value in the state.
  void textTable(String? val) {
    emit(state.copyWith(customDropdownTable: val));
  }

  /// Toggles the visibility of the data table.
  void showTable() {
    emit(state.copyWith(showTable: !state.showTable));
  }

  /// Toggles the checkbox state.
  void checkbox() {
    emit(state.copyWith(checkbox: !state.checkbox));
  }

  /// Sets the selected dropdown value for a specific row.
  void setSelectedDropdown(int rowIndex, String? value) {
    selectedDropdownPerRow[rowIndex] = value;
    emit(state.copyWith(customDropdownTable: value));
  }

  /// Gets the selected dropdown value for a specific row.
  String? getSelectedDropdown(int rowIndex) {
    return selectedDropdownPerRow[rowIndex];
  }

  /// Sets custom headers for the grid.
  void setCustomHeaders(List<String> headers) {
    emit(state.copyWith(customHeaders: headers));
  }

  /// Toggles the selection of a column.
  void toggleColumnSelection(String columnName) {
    final List<String> newSelectedColumns = List.from(state.selectedColumns);

    if (newSelectedColumns.contains(columnName)) {
      newSelectedColumns.remove(columnName);
    } else {
      newSelectedColumns.add(columnName);
    }

    emit(state.copyWith(selectedColumns: newSelectedColumns));
  }

  /// Clears all selected columns.
  void clearSelectedColumns() {
    emit(state.copyWith(selectedColumns: []));
  }

  /// Adds a custom item to the selected items list.
  void moveItemToSelected(CustomDragTargetDetails item) {
    if (!state.selectedItems.any((selectedItem) => selectedItem.data == item.data)) {
      final newAvailable = List<CustomDragTargetDetails>.from(state.availableItems)..remove(item);
      final newSelected = List<CustomDragTargetDetails>.from(state.selectedItems)..add(item);
      emit(state.copyWith(availableItems: newAvailable, selectedItems: newSelected));
    }
  }

  // ==================== Grid-related Methods ====================

  /// Generates the headers for the OnixGrid from the state's headers.
  List<OnixGridHeaderCell> generateMainTableHeaders() {
    List<String> effectiveHeaders = state.customHeaders.isNotEmpty ? state.customHeaders : state.headers;

    return effectiveHeaders
        .where((header) => header.trim().isNotEmpty)
        .map((header) {
      return OnixGridHeaderCell(
        headerCellField: header,
        title: header,
        cellType: const OnixTextCell(readOnly: false),
      );
    }).toList();
  }

  /// Checks if the second row of the table has any empty cells.
  bool cleanAndCheckEmptyCells(List<List<dynamic>> tableData) {
    if (tableData.isEmpty || tableData.length < 2) return false;

    final dataRow = tableData[1];
    for (final cell in dataRow) {
      if (cell == null || cell.toString().trim().isEmpty) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the text style of cells should be based on empty values.
  bool getCellTextStyle() {
    if (state.tableData.isEmpty || state.tableData.length < 2) return true;

    var row = state.tableData[1];
    for (var cellValue in row) {
      if (cellValue.toString().trim().isEmpty) return true;
    }
    return false;
  }
}