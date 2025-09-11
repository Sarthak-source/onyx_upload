import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
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
  List<PlutoColumn> plutoColumns = [];
  List<PlutoRow> plutoRows = [];

  // ==================== File Processing Methods ====================

  /// Handles picking and processing an Excel or CSV file.
  Future<void> pickAndProcessExcelFile() async {
    emit(state.copyWith(isLoading: true, plutoColumns: [], plutoRows: []));
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
        emit(state.copyWith(isLoading: false, plutoColumns: [], plutoRows: []));
      }
    } on PlatformException catch (e) {
      log("Unsupported operation: ${e.toString()}");
      emit(state.copyWith(isLoading: false, errorMessage: "Unsupported operation: ${e.message}", plutoColumns: [], plutoRows: []));
    } catch (e) {
      log("Error picking file: ${e.toString()}");
      emit(state.copyWith(isLoading: false, errorMessage: "Error picking file: ${e.toString()}", plutoColumns: [], plutoRows: []));
    }
  }

  /// Processes a CSV file from bytes.
  void _processCSVFile(Uint8List bytes) {
    try {
      String csvString = utf8.decode(bytes);
      List<List<dynamic>> fields = const CsvToListConverter().convert(csvString);

      _updateStateWithData(fields);
    } catch (e) {
      log("Error processing CSV: $e");
      emit(state.copyWith(errorMessage: 'Failed to process CSV file', isLoading: false, plutoColumns: [], plutoRows: []));
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

      _updateStateWithData(rows);
    } catch (e) {
      log("Error processing Excel: $e");
      emit(state.copyWith(errorMessage: 'Failed to process Excel file', isLoading: false, plutoColumns: [], plutoRows: []));
    }
  }

  /// Updates state with processed data and creates PlutoGrid columns/rows
  void _updateStateWithData(List<List<dynamic>> rows) {
    final headers = rows.isNotEmpty ? rows.first.map((e) => e.toString()).toList() : [];
    
    // Create PlutoGrid columns
    plutoColumns = headers.map((header) {
      return PlutoColumn(
        title: header,
        field: _toFieldName(header, headers.indexOf(header)),
        type: PlutoColumnType.text(),
        enableSorting: true,
        enableEditingMode: false,
        width: header.length * 10.0 + 50,
        textAlign: PlutoColumnTextAlign.center,
      );
    }).toList();

    // Create PlutoGrid rows (skip header row)
    plutoRows = rows.length > 1 
      ? rows.sublist(1).map((rowData) {
          final cells = <String, PlutoCell>{};
          
          for (int i = 0; i < headers.length; i++) {
            final value = i < rowData.length ? rowData[i].toString() : '';
            cells[headers[i]] = PlutoCell(value: value);
          }
          
          return PlutoRow(cells: cells);
        }).toList()
      : [];

    emit(state.copyWith(
      tableData: rows,
      headers: headers.cast<String>(),
      showTable: true,
      isLoading: false,
      selectedColumns: [],
      plutoColumns: plutoColumns,
      plutoRows: plutoRows,
    ));
  }

  /// Converts a column title to a safe field name
  String _toFieldName(String title, int index) {
    final safe = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return 'c${index}_$safe';
  }

  /// Builds PlutoGrid columns from selected column names
  void buildPlutoGridFromSelectedColumns(List<String> selectedColumns) {
    plutoColumns = selectedColumns.map((columnName) {
      return PlutoColumn(
        title: columnName,
        field: _toFieldName(columnName, selectedColumns.indexOf(columnName)),
        type: PlutoColumnType.text(),
        enableSorting: true,
        readOnly: true,
        width: columnName.length * 10.0 + 50,
      );
    }).toList();

    // Keep rows empty as requested
    plutoRows = [];

    emit(state.copyWith(
      plutoColumns: plutoColumns,
      plutoRows: plutoRows,
      showTable: true,
      selectedColumns: selectedColumns,
    ));
  }

  // ==================== State Management Methods ====================
  
  void updateSelectedHeaders(List<String> newHeaders) {
    emit(state.copyWith(headers: newHeaders, plutoColumns: [], plutoRows: []));
  }
  
  /// Toggles the visibility of the message banner.
  void showBanner() {
    emit(state.copyWith(showMessage: !state.showMessage, plutoColumns: [], plutoRows: []));
  }

  /// Updates the text field value in the state.
  void textShow(String? val) {
    emit(state.copyWith(customTextFildTable: val, plutoColumns: [], plutoRows: []));
  }

  /// Updates the dropdown table value in the state.
  void textTable(String? val) {
    emit(state.copyWith(customDropdownTable: val, plutoColumns: [], plutoRows: []));
  }

  /// Toggles the visibility of the data table.
  void showTable() {
    emit(state.copyWith(showTable: !state.showTable, plutoColumns: [], plutoRows: []));
  }

  /// Toggles the checkbox state.
  void checkbox() {
    emit(state.copyWith(checkbox: !state.checkbox, plutoColumns: [], plutoRows: []));
  }

  /// Sets the selected dropdown value for a specific row.
  void setSelectedDropdown(int rowIndex, String? value) {
    selectedDropdownPerRow[rowIndex] = value;
    emit(state.copyWith(customDropdownTable: value, plutoColumns: [], plutoRows: []));
  }

  /// Gets the selected dropdown value for a specific row.
  String? getSelectedDropdown(int rowIndex) {
    return selectedDropdownPerRow[rowIndex];
  }

  /// Sets custom headers for the grid.
  void setCustomHeaders(List<String> headers) {
    emit(state.copyWith(customHeaders: headers, plutoColumns: [], plutoRows: []));
  }

  /// Toggles the selection of a column.
  void toggleColumnSelection(String columnName) {
    final List<String> newSelectedColumns = List.from(state.selectedColumns);

    if (newSelectedColumns.contains(columnName)) {
      newSelectedColumns.remove(columnName);
    } else {
      newSelectedColumns.add(columnName);
    }

    emit(state.copyWith(selectedColumns: newSelectedColumns, plutoColumns: [], plutoRows: []));
  }

  /// Clears all selected columns.
  void clearSelectedColumns() {
    emit(state.copyWith(selectedColumns: [], plutoColumns: [], plutoRows: []));
  }

  /// Adds a custom item to the selected items list.
  void moveItemToSelected(CustomDragTargetDetails item) {
    if (!state.selectedItems.any((selectedItem) => selectedItem.data == item.data)) {
      final newAvailable = List<CustomDragTargetDetails>.from(state.availableItems)..remove(item);
      final newSelected = List<CustomDragTargetDetails>.from(state.selectedItems)..add(item);
      emit(state.copyWith(availableItems: newAvailable, selectedItems: newSelected, plutoColumns: [], plutoRows: []));
    }
  }

  // ==================== Grid-related Methods ====================

  /// Generates the headers for the grid from the state's headers.
  List<String> generateMainTableHeaders() {
    return state.customHeaders.isNotEmpty ? state.customHeaders : state.headers;
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