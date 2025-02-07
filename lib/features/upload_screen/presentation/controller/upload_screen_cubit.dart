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

  

  bool getCellTextStyle() {
    var row = state.tableData[0]; // Get the first row (index 0)

    bool hasEmptyCell = false;

    // Iterate over each cell in the row and check if any cell is empty
    for (var cellValue in row) {
      String trimmedValue = cellValue.toString().trim();
      log("test one - cell value: '${cellValue.toString()}'"); // Logs the raw cell value
      log("test one - trimmed cell value: '$trimmedValue'"); // Logs the trimmed value

      // If the trimmed value is empty or the original value was null/empty, mark it
      if (trimmedValue.isEmpty) {
        hasEmptyCell = true;
        log("test one - Found empty or null cell!");
        break; // Exit the loop early as we found an empty cell
      }
    }

    // Log whether we have an empty cell
    return hasEmptyCell;
  }

  showBanner() {
    emit(state.copyWith(showMessage: !state.showMessage));
  }

  // Method to pick a file and process it
  Future<void> pickFile() async {
    emit(state.copyWith(isLoading: true)); // Start loading
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
          errorMessage: 'No file selected', isLoading: false)); // Handle error
    }
  }

  // Process CSV file
  void _processCSVFile(Uint8List bytes) {
    String csvString = utf8.decode(bytes);
    List<List<dynamic>> fields = const CsvToListConverter().convert(csvString);

    emit(state.copyWith(
      tableData: fields.skip(1).toList(),
      headers: fields.isNotEmpty
          ? fields.first.map((e) => e.toString()).toList()
          : [],
      isLoading: false,
    ));
  }

  // Process Excel file
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
      tableData: rows.length > 1 ? rows.sublist(1) : [],
      headers:
          rows.isNotEmpty ? rows.first.map((e) => e.toString()).toList() : [],
      isLoading: false,
    ));
  }

  final mappingHeaders = [
    OnixGridHeaderCell(
      headerCellField: 'fileColumn',
      title: 'File Column', cellType: const OnixTextCell(readOnly: false),
      // Using a simple text cell; you can customize cellType if needed.
    ),
    OnixGridHeaderCell(
      headerCellField: 'dbColumn',
      title: 'Database Column',
      cellType: OnixDropdownCell(
        readOnly: false,
        isRequired: true,
        onChanged: (index, item) {},
        pgNo: 1,
        pgSz: 3,
        fetchItems: (_, __) async {
          await Future.delayed(const Duration(seconds: 2));
          return const [
            OnixGridItem(title: 'Item 1 ', value: "1"),
            OnixGridItem(title: 'Item 2', value: "2"),
            OnixGridItem(title: 'Item 3', value: "3")
          ];
        },
      ),
    ),
    OnixGridHeaderCell(
      headerCellField: 'comments',
      title: 'Comments',
      cellType: const OnixTextCell(readOnly: false),
    ),
  ];

  List<OnixGridHeaderCell> generateMainTableHeaders() {
  return state.headers
      .where((header) => header.trim().isNotEmpty) // Filter out empty headers
      .map((header) {
        log("generateMainTableHeaders: $header");
        return OnixGridHeaderCell(
          headerCellField: header,
          title: header,
          cellType: const OnixTextCell(readOnly: false),
        );
      })
      .toList();
}
}
