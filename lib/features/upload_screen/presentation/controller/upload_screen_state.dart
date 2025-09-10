import 'package:onyx_upload/core/extensions/widgets/models/drag_model.dart';

class FileUploadState {
  final List<List<dynamic>> tableData;
  final List<String> headers;
  final bool isLoading;
  final String? errorMessage;
  final bool showMessage;
  final bool showTable;
  final String? customTextFildTable;
  final String? customDropdownTable;
  final bool checkbox;
  final List<String> customHeaders;
  final bool hasEmptyCells;
  final bool showMissingData;
  // final int selectedRowIndex;
  final List<String> selectedColumns;
  final List<CustomDragTargetDetails> selectedItems;
  final List<CustomDragTargetDetails> availableItems;


  // Default constructor
  const FileUploadState({
    this.tableData = const [],
    this.headers = const [],
    this.isLoading = false,
    this.showMessage = false,
    this.showTable = false,
    this.errorMessage,
    this.customTextFildTable,
    this.customDropdownTable,
    this.checkbox = false,
    this.customHeaders = const [],
    this.hasEmptyCells = false,
    this.showMissingData = false,
    //  this.selectedRowIndex = 0,
     this.selectedColumns = const [],
     required this.selectedItems,
      this.availableItems = const [],
  });

  get isNotEmpty => null;

  // `copyWith` method for updating parts of the state
  FileUploadState copyWith({
    List<List<dynamic>>? tableData,
    List<String>? headers,
    bool? isLoading,
    bool? showMessage,
    bool? showTable,
    String? errorMessage,
    String? customTextFildTable,
    String? customDropdownTable,
    bool? checkbox,
    List<String>? customHeaders,
    bool? showMissingData,
    // int? selectedRowIndex,
    List<String>? selectedColumns,
    List<CustomDragTargetDetails>? selectedItems,
    List<CustomDragTargetDetails>? availableItems,

  }) {
    return FileUploadState(
        tableData: tableData ?? this.tableData,
        headers: headers ?? this.headers,
        isLoading: isLoading ?? this.isLoading,
        showMessage: showMessage ?? this.showMessage,
        showTable: showTable ?? this.showTable,
        errorMessage: errorMessage ?? this.errorMessage,
        customTextFildTable: customTextFildTable ?? this.customTextFildTable,
        customDropdownTable: customDropdownTable ?? this.customDropdownTable,
        checkbox: checkbox ?? this.checkbox,customHeaders: customHeaders ?? this.customHeaders, showMissingData: showMissingData ?? this.showMissingData,
        //  selectedRowIndex: selectedRowIndex ?? this.selectedRowIndex,
         selectedColumns: selectedColumns ?? this.selectedColumns,
         selectedItems: selectedItems ?? this.selectedItems,
         availableItems: availableItems ?? this.availableItems,
         );
        
        
  }
}
