class FileUploadState {
  final List<List<dynamic>> tableData;
  final List<String> headers;
  final bool isLoading;
  final String? errorMessage;
  final bool showMessage;
  final bool showTable;

  // Default constructor
  const FileUploadState({
    this.tableData = const [],
    this.headers = const [],
    this.isLoading = false,
    this.showMessage = false,
    this.showTable = false,
    this.errorMessage,
  });

  // `copyWith` method for updating parts of the state
  FileUploadState copyWith({
    List<List<dynamic>>? tableData,
    List<String>? headers,
    bool? isLoading,
    bool? showMessage,
    bool? showTable,
    String? errorMessage,
  }) {
    return FileUploadState(
      tableData: tableData ?? this.tableData,
      headers: headers ?? this.headers,
      isLoading: isLoading ?? this.isLoading,
      showMessage: showMessage ?? this.showMessage,
      showTable: showTable ?? this.showTable,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
