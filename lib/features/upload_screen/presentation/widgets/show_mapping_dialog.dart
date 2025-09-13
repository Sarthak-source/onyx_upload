import 'dart:developer';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:onyx_upload/core/extensions/widgets/dropdowns/Customr_dopdown_with_search.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:excel/excel.dart' hide Border;


class CreateTemplateFinalDialog extends StatefulWidget {
  final List<String> selectedColumns;
  const CreateTemplateFinalDialog({super.key, required this.selectedColumns});
  @override
  State<CreateTemplateFinalDialog> createState() => _CreateTemplateFinalDialogState();
}

class _CreateTemplateFinalDialogState extends State<CreateTemplateFinalDialog> {
  List<String> _selectedColumns = [];
  final List<String> _availableColumns = [
    "مبلغ الفاتورة",
    "الوحدة المالية",
    "مجموعات العروض الترويجية",
    "طريقة الدفع",
    "المخزن",
    "مجموعات المخازن",
    "رقم المنطقة للمخزن",
    "نوع العميل",
    "مجموعة العميل",
    "درجة العميل",
    "نشاط العميل",
    "تصنيف العميل",
    "رقم العميل",
    "عملاء نقاطي",
  ];
  bool _showGrid = false;
  bool _showColumnSelector = false;
  List<PlutoColumn> _gridColumns = [];
  List<PlutoRow> _gridRows = [];
  bool _isProcessingFile = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _selectedColumns = List.from(widget.selectedColumns);
    _availableColumns.removeWhere((item) => _selectedColumns.contains(item));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: const Color(0xFFF9F9F9),
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 700,
          height: 550,
          child: Column(
            children: [
              _buildDialogHeader(),
              if (_showColumnSelector)
                _buildColumnSelector()
              else
                _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _showColumnSelector ? "اختيار الأعمدة" : "إنشاء قالب جديد",
              style: AppTextStyles.styleRegular14(context, color: Colors.black87),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: kGrayIX,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: kTextFiledColor,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnSelector() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'اسحب الأعمدة من القائمة المتاحة إلى القائمة المحددة',
                      style: AppTextStyles.styleRegular14(context, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  _buildColumnList(
                    title: 'الأعمدة المتاحة',
                    items: _availableColumns,
                    isSource: true,
                    color: kSkyDarkColor,
                  ),
                  const SizedBox(width: 16),
                  _buildColumnList(
                    title: 'الأعمدة المحددة',
                    items: _selectedColumns,
                    isSource: false,
                    color: kCardGreenColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showColumnSelector = false;
                    });
                  },
                  child: Text('إلغاء', style: AppTextStyles.styleRegular14(context)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showColumnSelector = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCardGreenColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: Text('تم', style: AppTextStyles.styleLight14(context, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnList({
    required String title,
    required List<String> items,
    required bool isSource,
    required Color color,
  }) {
    return Expanded(
      child: DragTarget<String>(
        onWillAccept: (data) => true,
        onAccept: (data) {
          _handleColumnDrop(data, isSource);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          items.length.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            isSource ? 'اسحب من هنا' : 'اسحب الأعمدة هنا',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return _buildDraggableColumn(items[index], isSource);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableColumn(String columnName, bool isSource) {
    return Draggable<String>(
      data: columnName,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSource ? kSkyDarkColor : kCardGreenColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            columnName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(columnName, style: TextStyle(color: Colors.grey.shade500)),
      ),
      child: GestureDetector(
        onTap: () {
          _handleColumnTap(columnName, isSource);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSource ? kSkyDarkColor.withOpacity(0.1) : kCardGreenColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSource ? kSkyDarkColor : kCardGreenColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.drag_handle, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  columnName,
                  style: TextStyle(
                    color: isSource ? kSkyDarkColor : kCardGreenColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleColumnTap(String columnName, bool isSource) {
    setState(() {
      if (isSource) {
        if (!_selectedColumns.contains(columnName)) {
          _selectedColumns.add(columnName);
        }
        _availableColumns.remove(columnName);
      } else {
        if (!_availableColumns.contains(columnName)) {
          _availableColumns.add(columnName);
        }
        _selectedColumns.remove(columnName);
      }
      _availableColumns.sort();
      _selectedColumns.sort();
    });
  }

  void _handleColumnDrop(String columnName, bool isSource) {
    setState(() {
      if (isSource) {
        if (!_availableColumns.contains(columnName)) {
          _availableColumns.add(columnName);
        }
        _selectedColumns.remove(columnName);
      } else {
        if (!_selectedColumns.contains(columnName)) {
          _selectedColumns.add(columnName);
        }
        _availableColumns.remove(columnName);
      }
      _availableColumns.sort();
      _selectedColumns.sort();
    });
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Column(
        children: [
          _buildTemplateDropdown(),
          _buildGridArea(),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildTemplateDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomDropDownWithSearch(
              fldNm: "templateDropdown",
              hint: "اختر القالب",
              list: const ["قالب 1", "قالب 2"],
              isRequired: true,
              onChanged: (value) {
                log("تم اختيار القالب: $value");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridArea() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: _isProcessingFile
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _showGrid && _gridColumns.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PlutoGrid(
                          columns: _gridColumns,
                          rows: _gridRows,
                          onLoaded: (PlutoGridOnLoadedEvent event) {},
                          configuration: PlutoGridConfiguration(
                            columnSize: const PlutoGridColumnSizeConfig(
                              autoSizeMode: PlutoAutoSizeMode.equal,
                            ),
                            style: PlutoGridStyleConfig(
                              cellTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
                              columnTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
                              gridBackgroundColor: Colors.transparent,
                              cellColorInEditState: Colors.transparent,
                              activatedColor: Colors.transparent,
                              activatedBorderColor: kSkyDarkColor,
                              inactivatedBorderColor: Colors.grey.shade300,
                              gridBorderColor: Colors.grey.shade300,
                              columnHeight: 40,
                              rowHeight: 40,
                              columnFilterHeight: 40,
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'سيظهر الجدول هنا بعد الضغط على تنفيذ',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kSkyDarkColor,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              setState(() {
                _showColumnSelector = true;
                _errorMessage = '';
              });
            },
            icon: const Icon(Icons.view_column, color: Colors.white, size: 20),
            label: Text(
              "اختيار الأعمدة",
              style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCardGreenColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _selectedColumns.isNotEmpty ? _pickAndProcessExcelFile : null,
                icon: const Icon(Icons.file_upload, color: Colors.white, size: 20),
                label: Text(
                  "استيراد الملف",
                  style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _selectedColumns.isNotEmpty ? _buildGrid : null,
                icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                label: Text(
                  "تنفيذ",
                  style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _gridRows.isNotEmpty ? _saveDataToExcel : null,
                icon: const Icon(Icons.save, color: Colors.white, size: 20),
                label: Text(
                  "حفظ",
                  style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _buildGrid() {
    if (_selectedColumns.isEmpty) {
      setState(() {
        _errorMessage = "يجب اختيار الأعمدة أولاً.";
      });
      return;
    }

    final newGridColumns = List.generate(_selectedColumns.length, (i) {
      return PlutoColumn(
        title: _selectedColumns[i],
        field: _toFieldName(_selectedColumns[i], i),
        type: PlutoColumnType.text(),
        enableSorting: true,
        readOnly: true,
      );
    });

    setState(() {
      _gridColumns = newGridColumns;
      _gridRows = [];
      _showGrid = true;
      _errorMessage = '';
    });
  }

  Future<void> _pickAndProcessExcelFile() async {
    setState(() {
      _isProcessingFile = true;
      _errorMessage = '';
    });

    if (_selectedColumns.isEmpty) {
      setState(() {
        _errorMessage = "الرجاء اختيار الأعمدة أولاً قبل استيراد الملف.";
        _isProcessingFile = false;
      });
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        Uint8List? fileBytes = result.files.single.bytes;

        if (fileBytes == null) {
          throw Exception("لم يتم العثور على محتوى في الملف.");
        }

        var excel = Excel.decodeBytes(fileBytes);

        List<String> sheetNames = excel.tables.keys.toList();
        if (sheetNames.isEmpty) {
          throw Exception("الملف لا يحتوي على أي ورقات.");
        }
        var sheet = excel.tables[sheetNames.first]!;
        List<String> excelHeaders = [];
        if (sheet.rows.isNotEmpty) {
          excelHeaders = sheet.rows.first.map((cell) => cell?.value.toString() ?? '').toList();
        }

        for (var column in _selectedColumns) {
          if (!excelHeaders.contains(column)) {
            throw Exception("توجد أعمدة مختارة غير موجودة في ملف Excel. الأعمدة غير الموجودة: $column");
          }
        }

        final Map<String, int> headerMap = {};
        for (int i = 0; i < excelHeaders.length; i++) {
          headerMap[excelHeaders[i]] = i;
        }

        List<PlutoRow> rows = [];
        for (int i = 1; i < sheet.rows.length; i++) {
          var dataRow = sheet.rows[i];
          Map<String, PlutoCell> cells = {};
          for (var selectedColumn in _selectedColumns) {
            int? colIndex = headerMap[selectedColumn];
            if (colIndex != null && colIndex < dataRow.length) {
              final cellValue = dataRow[colIndex]?.value?.toString() ?? '';
              cells[_toFieldName(selectedColumn, _selectedColumns.indexOf(selectedColumn))] = PlutoCell(value: cellValue);
            }
          }
          rows.add(PlutoRow(cells: cells));
        }

        final newGridColumns = List.generate(_selectedColumns.length, (i) {
          return PlutoColumn(
            title: _selectedColumns[i],
            field: _toFieldName(_selectedColumns[i], i),
            type: PlutoColumnType.text(),
            enableSorting: true,
            readOnly: true,
          );
        });

        setState(() {
          _gridColumns = newGridColumns;
          _gridRows = rows;
          _showGrid = true;
          _isProcessingFile = false;
          _errorMessage = '';
        });
      } else {
        setState(() {
          _isProcessingFile = false;
        });
      }
    } catch (e) {
      log("حدث خطأ في معالجة الملف: $e");
      setState(() {
        String friendlyMessage;
        if (e.toString().contains('path')) {
            friendlyMessage = "حدث خطأ في قراءة الملف. يرجى التأكد من أن الملف غير تالف والمحاولة مرة أخرى.";
        } else {
            friendlyMessage = e.toString().replaceFirst('Exception: ', '');
        }
        _errorMessage = friendlyMessage;
        _isProcessingFile = false;
        _showGrid = false;
      });
    }
  }

  Future<void> _saveDataToExcel() async {
    if (_gridRows.isEmpty) {
      setState(() {
        _errorMessage = "الجدول فارغ، لا توجد بيانات للحفظ.";
      });
      return;
    }

    try {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Write headers
      for (var i = 0; i < _gridColumns.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = _gridColumns[i].title as CellValue?;
      }

      // Write data rows
      for (var i = 0; i < _gridRows.length; i++) {
        final row = _gridRows[i];
        for (var j = 0; j < _gridColumns.length; j++) {
          final cellValue = row.cells[_gridColumns[j].field]?.value.toString() ?? '';
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = cellValue as CellValue?;
        }
      }

      final Uint8List excelBytes = Uint8List.fromList(excel.encode()!);
      final String fileName = "بيانات_محفوظة_${DateTime.now().toIso8601String()}.xlsx";

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: excelBytes,
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حفظ الملف بنجاح!')),
      );

    } catch (e) {
      log("حدث خطأ في الحفظ: $e");
      setState(() {
        _errorMessage = "حدث خطأ أثناء حفظ الملف. يرجى المحاولة مرة أخرى.";
      });
    }
  }

  String _toFieldName(String title, int index) {
    final safe = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]+'), '');
    return 'c${index}_$safe';
  }
}