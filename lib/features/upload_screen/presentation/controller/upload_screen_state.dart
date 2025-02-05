class FileUploadState {
  final List<List<dynamic>> tableData;
  final List<String> headers;
  final bool isLoading;
  final String? errorMessage;

  // Default constructor
  const FileUploadState({
    this.tableData = const [],
    this.headers = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  // `copyWith` method for updating parts of the state
  FileUploadState copyWith({
    List<List<dynamic>>? tableData,
    List<String>? headers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FileUploadState(
      tableData: tableData ?? this.tableData,
      headers: headers ?? this.headers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
