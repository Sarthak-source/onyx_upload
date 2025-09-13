import 'package:pluto_grid/pluto_grid.dart';
import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';

class FileUploadState {
  final List<String> headers;
  final List<List<dynamic>> tableData;
  final bool isLoading;
  final bool showTable;
  final bool showMessage;
  final String? errorMessage;
  final String? customTextFildTable;
  final String? customDropdownTable;
  final bool checkbox;
  final List<String> customHeaders;
  final List<String> selectedColumns;
  final List<CustomDragTargetDetails> availableItems;
  final List<CustomDragTargetDetails> selectedItems;
  final List<PlutoColumn> plutoColumns;
  final List<PlutoRow> plutoRows;
  final bool ignoreHeaderErrors;
  final String? selectedTemplate;
  final bool hasDataError;

  FileUploadState({
    this.headers = const [],
    this.tableData = const [],
    this.isLoading = false,
    this.showTable = false,
    this.showMessage = false,
    this.errorMessage,
    this.customTextFildTable,
    this.customDropdownTable,
    this.checkbox = false,
    this.customHeaders = const [],
    this.selectedColumns = const [],
    this.availableItems = const [],
    this.selectedItems = const [],
    this.plutoColumns = const [],
    this.plutoRows = const [],
    this.ignoreHeaderErrors = false,
    this.selectedTemplate,
    this.hasDataError = false,
  });

  FileUploadState copyWith({
    List<String>? headers,
    List<List<dynamic>>? tableData,
    bool? isLoading,
    bool? showTable,
    bool? showMessage,
    String? errorMessage,
    String? customTextFildTable,
    String? customDropdownTable,
    bool? checkbox,
    List<String>? customHeaders,
    List<String>? selectedColumns,
    List<CustomDragTargetDetails>? availableItems,
    List<CustomDragTargetDetails>? selectedItems,
    List<PlutoColumn>? plutoColumns,
    List<PlutoRow>? plutoRows,
    bool? ignoreHeaderErrors,
    String? selectedTemplate,
    bool? hasDataError,
  }) {
    return FileUploadState(
      headers: headers ?? this.headers,
      tableData: tableData ?? this.tableData,
      isLoading: isLoading ?? this.isLoading,
      showTable: showTable ?? this.showTable,
      showMessage: showMessage ?? this.showMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      customTextFildTable: customTextFildTable ?? this.customTextFildTable,
      customDropdownTable: customDropdownTable ?? this.customDropdownTable,
      checkbox: checkbox ?? this.checkbox,
      customHeaders: customHeaders ?? this.customHeaders,
      selectedColumns: selectedColumns ?? this.selectedColumns,
      availableItems: availableItems ?? this.availableItems,
      selectedItems: selectedItems ?? this.selectedItems,
      plutoColumns: plutoColumns ?? this.plutoColumns,
      plutoRows: plutoRows ?? this.plutoRows,
      ignoreHeaderErrors: ignoreHeaderErrors ?? this.ignoreHeaderErrors,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      hasDataError: hasDataError ?? this.hasDataError,
    );
  }
}