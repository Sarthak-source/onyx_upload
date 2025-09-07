import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class FileUploadCubit extends Cubit<FileUploadState> {
  FileUploadCubit() : super(const FileUploadState());

  Map<int, String?> selectedDropdownPerRow = {};

  // ================== Methods ==================
 bool cleanAndCheckEmptyCells(List<List<dynamic>> tableData) {
    if (tableData.isEmpty) return false;

    for (int i = 0; i < tableData.length; i++) {
      for (final cell in tableData[i]) {
        if (cell == null || cell.toString().trim().isEmpty) {
          return true;
        }
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

  void toggleBanner() {
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

  // ================== File Processing ==================
  Future<void> pickFile() async {
    emit(state.copyWith(isLoading: true));
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    );

    if (result != null) {
      String fileExtension = result.files.single.extension ?? '';

      if (fileExtension == 'csv') {
        _processCSVFile(result.files.single.bytes!);
      } else if (fileExtension == 'xls' || fileExtension == 'xlsx') {
        _processExcelFile(result.files.single.bytes!);
      }
    } else {
      emit(state.copyWith(
          errorMessage: 'No file selected', isLoading: false));
    }
  }
  void toggleShowMissingData() {
  print('toggleShowMissingData called - current: ${state.showMissingData}, new: ${!state.showMissingData}');
  emit(state.copyWith(showMissingData: !state.showMissingData));
}
  void showBanner() {
  print('showBanner called - showMissingData: true');
  emit(state.copyWith(
    showMessage: true,
    showMissingData: true,
  ));
}
   bool hasEmptyCellsInRow(int rowIndex) {
    if (state.tableData.isEmpty || rowIndex >= state.tableData.length) {
      return false;
    }
    
    final row = state.tableData[rowIndex];
    for (var cell in row) {
      if (cell == null || cell.toString().trim().isEmpty) {
        return true;
      }
    }
    return false;
  }

  void _processCSVFile(Uint8List bytes) {
    String csvString = utf8.decode(bytes);
    List<List<dynamic>> fields = const CsvToListConverter().convert(csvString);

    emit(state.copyWith(
      tableData: fields.skip(1).toList(),
      headers: fields.isNotEmpty
          ? fields.first.map((e) => e.toString()).toList()
          : [],
      isLoading: false,
      customHeaders: [], 
    ));
  }

  void _processExcelFile(Uint8List bytes) {
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
    tableData: rows.length > 1 ? rows.sublist(1) : [], // تغيير من 2 إلى 1
    headers: rows.isNotEmpty ? rows.first.map((e) => e.toString()).toList() : [],
    isLoading: false,
    customHeaders: [],
  ));
}

  // ================== Generate Grid Headers ==================
  List<OnixGridHeaderCell> generateMainTableHeaders() {
    List<String> effectiveHeaders = state.customHeaders.isNotEmpty 
        ? state.customHeaders 
        : state.headers;

    return effectiveHeaders
        .where((header) => header.trim().isNotEmpty)
        .map((header) {
      log("generateMainTableHeaders: $header");
      return OnixGridHeaderCell(
        headerCellField: header,
        title: header,
        cellType: const OnixTextCell(readOnly: false),
      );
    }).toList();
  }

  bool _hasValidHeaders(List<dynamic> headers) {
    if (headers.isEmpty) return false;
    
    int validCount = 0;
    for (var header in headers) {
      String headerStr = header.toString();
      if (headerStr.isNotEmpty && 
          headerStr.length > 1 && 
          !headerStr.trim().contains(RegExp(r'^[0-9\.]+$'))) {
        validCount++;
      }
    }
    
    return validCount >= headers.length / 1;
  }
}