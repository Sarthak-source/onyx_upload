import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/dropdowns/Customr_dopdown_with_search.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../controller/upload_screen_cubit.dart';

class CreateTemplateFinalDialog extends StatefulWidget {
  const CreateTemplateFinalDialog({super.key, required List<String> selectedColumns});

  @override
  State<CreateTemplateFinalDialog> createState() => _CreateTemplateFinalDialogState();
}

class _CreateTemplateFinalDialogState extends State<CreateTemplateFinalDialog> {
  List<String> _selectedColumns = [];
  List<String> _availableColumns = [
    
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FileUploadCubit(),
        child: Dialog(
          backgroundColor: const Color(0xFFF9F9F9),
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 700, // زيادة العرض لاستيعاب محدد الأعمدة
            height: 550, // زيادة الارتفاع لاستيعاب محدد الأعمدة
            child: Column(
              children: [
                // ====== العنوان العلوي للديالوج ======
                Container(
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
                ),

                // ====== محتوى متغير بناءً على حالة العرض ======
                if (_showColumnSelector)
                  _buildColumnSelector()
                else
                  _buildMainContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====== بناء واجهة اختيار الأعمدة ======
  Widget _buildColumnSelector() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // تعليمات
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
            
            // منطقة السحب والإفلات
            Expanded(
              child: Row(
                children: [
                  // الأعمدة المتاحة
                  _buildColumnList(
                    title: 'الأعمدة المتاحة',
                    items: _availableColumns,
                    isAvailable: true,
                    color: kSkyDarkColor,
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // الأعمدة المحددة
                  _buildColumnList(
                    title: 'الأعمدة المحددة',
                    items: _selectedColumns,
                    isAvailable: false,
                    color: kCardGreenColor,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // أزرار التحكم
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

  // ====== بناء قائمة الأعمدة قابلة للسحب ======
  Widget _buildColumnList({
    required String title,
    required List<String> items,
    required bool isAvailable,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            // عنوان القائمة
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
            
            // قائمة العناصر
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        isAvailable ? 'اسحب من هنا' : 'اسحب الأعمدة هنا',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildDraggableColumn(items[index], isAvailable);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ====== بناء عنصر عمود قابل للسحب ======
  Widget _buildDraggableColumn(String columnName, bool isAvailable) {
    return Draggable<String>(
      data: columnName,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isAvailable ? kSkyDarkColor : kCardGreenColor,
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
      child: DragTarget<String>(
        onWillAccept: (data) => true,
        onAccept: (data) {
          _handleColumnDrop(data, isAvailable);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isAvailable ? kSkyDarkColor.withOpacity(0.1) : kCardGreenColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isAvailable ? kSkyDarkColor : kCardGreenColor,
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
                      color: isAvailable ? kSkyDarkColor : kCardGreenColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ====== معالجة سحب وإفلات الأعمدة ======
  void _handleColumnDrop(String columnName, bool isAvailable) {
    setState(() {
      if (isAvailable) {
        // إفلات في القائمة المتاحة
        if (!_availableColumns.contains(columnName)) {
          _availableColumns.add(columnName);
        }
        _selectedColumns.remove(columnName);
      } else {
        // إفلات في القائمة المحددة
        if (!_selectedColumns.contains(columnName)) {
          _selectedColumns.add(columnName);
        }
        _availableColumns.remove(columnName);
      }
    });
  }

  // ====== بناء المحتوى الرئيسي ======
  Widget _buildMainContent() {
    return Expanded(
      child: Column(
        children: [
          // ====== حقل اسم القالب ======
          Padding(
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
                )
              ],
            ),
          ),

          // ====== منطقة عرض الجدول ======
          if (_showGrid && _gridColumns.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PlutoGrid(
                    columns: _gridColumns,
                    rows: _gridRows,
                    onLoaded: (PlutoGridOnLoadedEvent event) {},
                    configuration: PlutoGridConfiguration(
                      columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode.equal,
                      ),
                      style: PlutoGridStyleConfig(
                        cellTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
                        columnTextStyle: AppTextStyles.styleRegular14(context, color: Colors.white),
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
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'سيظهر الجدول هنا بعد الضغط على تنفيذ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

          // ====== الأزرار السفلية ======
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCardGreenColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showColumnSelector = true;
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
                      onPressed: () {
                        context.read<FileUploadCubit>().pickAndProcessExcelFile();
                      },
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
                      onPressed: _selectedColumns.isNotEmpty ? () {
                        _buildGrid();
                      } : null,
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                      label: Text(
                        "تنفيذ",
                        style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====== بناء الجدول بناءً على الأعمدة المحددة ======
  void _buildGrid() {
    setState(() {
      _showGrid = false;
    });

    _gridColumns = List.generate(_selectedColumns.length, (i) {
      return PlutoColumn(
        title: _selectedColumns[i],
        field: _toFieldName(_selectedColumns[i], i),
        type: PlutoColumnType.text(),
        enableSorting: true,
        readOnly: true,
      );
    });

    _gridRows = [];

    setState(() {
      _showGrid = true;
    });
  }

  // ====== تحويل اسم العمود إلى اسم حقل آمن ======
  String _toFieldName(String title, int index) {
    final safe = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return 'c${index}_$safe';
  }
}