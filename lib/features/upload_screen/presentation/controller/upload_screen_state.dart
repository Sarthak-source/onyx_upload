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
        checkbox: checkbox ?? this.checkbox,customHeaders: customHeaders ?? this.customHeaders, showMissingData: showMissingData ?? this.showMissingData,);
        
        
  }
}
