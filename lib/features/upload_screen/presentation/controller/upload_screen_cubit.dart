import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  FileUploadCubit() : super(FileUploadState());

  Map<int, String?> selectedDropdownPerRow = {};

  // ==================== معالجة الملفات ====================

  Future<void> pickAndProcessExcelFile() async {
    emit(state.copyWith(
      isLoading: true, 
      plutoColumns: [], 
      plutoRows: [], 
      hasDataError: false,
      errorMessage: null,
    ));
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        
        if (bytes != null) {
          if (file.extension == 'csv') {
            _processCSVFile(bytes);
          } else if (file.extension == 'xlsx' || file.extension == 'xls') {
            _processExcelFile(bytes);
          } else {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: 'نوع الملف غير مدعوم',
              hasDataError: true,
            ));
          }
        } else {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'الملف فارغ',
            hasDataError: true,
          ));
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      log("Error picking file: ${e.toString()}");
      emit(state.copyWith(
        isLoading: false, 
        errorMessage: "خطأ في اختيار الملف: ${e.toString()}",
        hasDataError: true,
      ));
    }
  }

  void _processCSVFile(Uint8List bytes) {
    try {
      String csvString = utf8.decode(bytes);
      List<List<dynamic>> fields = const CsvToListConverter().convert(csvString);
      _updateStateWithData(fields);
    } catch (e) {
      log("Error processing CSV: $e");
      emit(state.copyWith(
        errorMessage: 'فشل في معالجة ملف CSV',
        isLoading: false,
        hasDataError: true,
      ));
    }
  }

  void _processExcelFile(Uint8List bytes) {
    try {
      var excel = Excel.decodeBytes(bytes);
      if (excel.tables.isEmpty) {
        emit(state.copyWith(
          errorMessage: 'الملف لا يحتوي على أي جداول',
          isLoading: false,
          hasDataError: true,
        ));
        return;
      }

      String firstSheetName = excel.tables.keys.first;
      var sheet = excel.tables[firstSheetName];

      List<List<dynamic>> rows = [];
      if (sheet != null) {
        for (var row in sheet.rows) {
          // تجاهل الصفوف الفارغة تمامًا
          final nonEmptyRow = row.where((cell) => cell?.value != null).toList();
          if (nonEmptyRow.isNotEmpty) {
            rows.add(nonEmptyRow.map((cell) => cell?.value ?? '').toList());
          }
        }
      }

      _updateStateWithData(rows);
    } catch (e) {
      log("Error processing Excel: $e");
      emit(state.copyWith(
        errorMessage: 'فشل في معالجة ملف Excel',
        isLoading: false,
        hasDataError: true,
      ));
    }
  }

  void _updateStateWithData(List<List<dynamic>> rows) {
    if (rows.isEmpty) {
      emit(state.copyWith(
        tableData: [],
        headers: [],
        showTable: false,
        isLoading: false,
        plutoColumns: [],
        plutoRows: [],
        hasDataError: true,
        errorMessage: 'الملف لا يحتوي على بيانات',
      ));
      return;
    }

    final headers = rows.first.map((e) => e.toString()).toList();
    
    // معالجة جميع الصفوف لضمان التوافق
    final processedRows = _processAllRows(rows, headers.length);

    // إنشاء أعمدة Pluto Grid
    final newPlutoColumns = headers.map((header) {
      return PlutoColumn(
        title: header,
        field: _toFieldName(header),
        type: PlutoColumnType.text(),
        enableSorting: true,
        enableEditingMode: false,
        width: header.length * 10.0 + 50,
        textAlign: PlutoColumnTextAlign.center,
      );
    }).toList();

    // إنشاء صفوف Pluto Grid (تخطي صف العناوين)
    final List<PlutoRow> newPlutoRows = processedRows.length > 1 
      ? processedRows.sublist(1).map<PlutoRow>((rowData) {
          final cells = <String, PlutoCell>{};
          
          for (int i = 0; i < headers.length; i++) {
            final value = i < rowData.length ? rowData[i].toString() : '';
            cells[_toFieldName(headers[i])] = PlutoCell(value: value);
          }
          
          return PlutoRow(cells: cells);
        }).toList()
      : [];

    emit(state.copyWith(
      tableData: processedRows,
      headers: headers,
      showTable: true,
      isLoading: false,
      selectedColumns: [],
      plutoColumns: newPlutoColumns,
      plutoRows: newPlutoRows,
      hasDataError: false,
      errorMessage: null,
    ));
  }

  // معالجة جميع الصفوف لضمان التوافق
  List<List<dynamic>> _processAllRows(List<List<dynamic>> rows, int expectedLength) {
    return rows.map((row) => _processRow(row, expectedLength)).toList();
  }

  // معالجة صف فردي
  List<dynamic> _processRow(List<dynamic> row, int expectedLength) {
    if (row.length == expectedLength) {
      return row;
    }
    
    if (row.length < expectedLength) {
      return List<dynamic>.from(row)..addAll(
        List.filled(expectedLength - row.length, '')
      );
    }
    
    return row.sublist(0, expectedLength);
  }

  String _toFieldName(String title) {
    return title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  void ignoreHeaderErrors() {
    emit(state.copyWith(ignoreHeaderErrors: true, hasDataError: false));
  }

  void setSelectedTemplate(String templateName) {
    emit(state.copyWith(selectedTemplate: templateName));
  }

  void buildPlutoGridFromSelectedColumns(List<String> selectedColumns) {
    final newPlutoColumns = selectedColumns.map((columnName) {
      return PlutoColumn(
        title: columnName,
        field: _toFieldName(columnName),
        type: PlutoColumnType.text(),
        enableSorting: true,
        readOnly: true,
        width: columnName.length * 10.0 + 50,
      );
    }).toList();

    final List<PlutoRow> newPlutoRows = [];

    emit(state.copyWith(
      plutoColumns: newPlutoColumns,
      plutoRows: newPlutoRows,
      showTable: true,
      selectedColumns: selectedColumns,
      hasDataError: false,
    ));
  }

  // ==================== دوال إدارة الحالة ====================
  
  void updateSelectedHeaders(List<String> newHeaders) {
    emit(state.copyWith(headers: newHeaders));
  }
  
  void showBanner() {
    emit(state.copyWith(showMessage: !state.showMessage));
  }

  void textShow(String? val) {
    emit(state.copyWith(customTextFildTable: val));
  }

  void textTable(String? val) {
    emit(state.copyWith(customDropdownTable: val));
  }

  void showTable() {
    emit(state.copyWith(showTable: !state.showTable));
  }

  void checkbox() {
    emit(state.copyWith(checkbox: !state.checkbox));
  }

  void setSelectedDropdown(int rowIndex, String? value) {
    selectedDropdownPerRow[rowIndex] = value;
    emit(state.copyWith(customDropdownTable: value));
  }

  String? getSelectedDropdown(int rowIndex) {
    return selectedDropdownPerRow[rowIndex];
  }

  void setCustomHeaders(List<String> headers) {
    emit(state.copyWith(customHeaders: headers));
  }

  void toggleColumnSelection(String columnName) {
    final List<String> newSelectedColumns = List.from(state.selectedColumns);

    if (newSelectedColumns.contains(columnName)) {
      newSelectedColumns.remove(columnName);
    } else {
      newSelectedColumns.add(columnName);
    }

    emit(state.copyWith(selectedColumns: newSelectedColumns));
  }

  void clearSelectedColumns() {
    emit(state.copyWith(selectedColumns: []));
  }

  void moveItemToSelected(CustomDragTargetDetails item) {
    if (!state.selectedItems.any((selectedItem) => selectedItem.data == item.data)) {
      final newAvailable = List<CustomDragTargetDetails>.from(state.availableItems)..remove(item);
      final newSelected = List<CustomDragTargetDetails>.from(state.selectedItems)..add(item);
      emit(state.copyWith(
        availableItems: newAvailable, 
        selectedItems: newSelected
      ));
    }
  }

  // ==================== دوال الشبكة ====================

  List<String> generateMainTableHeaders() {
    return state.customHeaders.isNotEmpty ? state.customHeaders : state.headers;
  }

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

  bool getCellTextStyle() {
    if (state.tableData.isEmpty || state.tableData.length < 2) return true;

    var row = state.tableData[1];
    for (var cellValue in row) {
      if (cellValue.toString().trim().isEmpty) return true;
    }
    return false;
  }
}