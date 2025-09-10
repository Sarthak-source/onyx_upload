import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/buttons/custom_text_icon_button.dart';
import 'package:onyx_upload/core/extensions/widgets/dropdowns/Customr_dopdown_with_search.dart';
import 'package:onyx_upload/core/extensions/widgets/responsive/spacer.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/main_page_table.dart';

class TableReview extends StatelessWidget {
  TableReview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final bool hasEmptyCells = context
            .read<FileUploadCubit>()  
            .cleanAndCheckEmptyCells(state.tableData);
            
        final TextStyle cellTextStyle =
            context.read<FileUploadCubit>().getCellTextStyle()
                ? AppTextStyles.styleRegular14(context,
                    color: const Color(0xff4b4b4b))
                : AppTextStyles.styleRegular14(context, color: Colors.white);

        List<String> headers = state.customHeaders.isNotEmpty 
            ? state.customHeaders 
            : state.headers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TitleDialogPage(title: 'Upload'),

            // Checkbox "Make first row address"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: state.checkbox,
                    onChanged: (bool? value) {
                      context.read<FileUploadCubit>().checkbox();
                    },
                    fillColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color(0xff0C69C0);
                      }
                      return Colors.white;
                    }),
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                  Text(
                    "Make the first row in the file the address",
                    style: AppTextStyles.styleRegular14(context),
                  ),
                ],
              ),
            ),

            const HSpacer(15),

            // Template dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Template'),
                SizedBox(
                  width: 400,
                  child: CustomDropDownWithSearch(
                    fldNm: "templateDropdown",
                    hint: "Choose Template*",
                    list: const ["Template 1", "Template 2", "Template 3"],
                    isRequired: true,
                    selectedItem: state.customTextFildTable,
                    onChanged: (value) {
                      context.read<FileUploadCubit>().textShow(value);
                    },
                  ),
                ),
              ],
            ),

            const HSpacer(10),

            // Message Banner
            if (state.showMessage) ...[
              MessageBanner(
                message: hasEmptyCells
                    ? "Warning! Data Missing in line (1)."
                    : "Everything seems valid.",
                backgroundColor: hasEmptyCells
                    ? kWarningMColor.shade300
                    : const Color(0xffFEFAF5),
                textColor: hasEmptyCells ? kWarningMColor.shade500 : Colors.black,
              ),
              const HSpacer(10),
            ],

            // DataTable
            Expanded(
              child: state.tableData.isNotEmpty 
                  ? Column(
                      children: [
                        // عناصر التحكم للأعمدة فقط
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          color: Colors.blue[50],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (state.selectedColumns.isNotEmpty)
                                TextButton(
                                  onPressed: () => context.read<FileUploadCubit>().clearSelectedColumns(),
                                  child: Text('Show All Columns'),
                                ),
                              PopupMenuButton<String>(
                                itemBuilder: (context) {
                                  return headers.map((header) {
                                    final isSelected = state.selectedColumns.contains(header);
                                    return PopupMenuItem<String>(
                                      value: header,
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                            color: isSelected ? Colors.blue : Colors.grey,
                                          ),
                                          SizedBox(width: 8),
                                          Text(header),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                onSelected: (header) {
                                  context.read<FileUploadCubit>().toggleColumnSelection(header);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.view_column, size: 20, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Manage Columns'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // DataTable
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(kSkyDarkColor),
                              headingRowHeight: 40,
                              headingTextStyle: AppTextStyles.styleRegular14(context,
                                  color: Colors.white),
                              dataRowMinHeight: 60,
                              dataRowMaxHeight: 70,
                              columns: const [
                                DataColumn(label: Text("File Column")),
                                DataColumn(label: Text("Database Column")),
                                DataColumn(label: Text("Comments")),
                              ],
                              rows: _buildDataRows(context, state),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.table_chart, size: 50, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            "No data available",
                            style: AppTextStyles.styleRegular16(context).copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Please upload a file to see the data",
                            style: AppTextStyles.styleRegular14(context).copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const HSpacer(20),

            // Bottom Buttons
            _buildBottomButtons(context, state),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context, FileUploadState state) {
    if (state.showMessage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomTextIconButton(
            onPressed: () {
              final cubit = context.read<FileUploadCubit>();
              cubit.showTable();
              Future.delayed(const Duration(milliseconds: 100), () {
                // Navigator.push(
                  // context,
                  // MaterialPageRoute(
                      // builder: (context) => const ExcelGridViewer()),
                // );
              });
            },
            title: "Upload",
            icon: Icons.upload_file,
            iconColor: Colors.white,
            bgColor: kCardGreenColor,
            txtColor: Colors.white,
            iconSize: 24,
            height: 35,
          ),
          const SizedBox(width: 8),
          CustomTextIconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            title: "Cancel",
            icon: Icons.close,
            iconColor: Colors.white,
            bgColor: kTextFieldColor,
            txtColor: Colors.white,
            iconSize: 24,
            height: 35,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.tableData.isNotEmpty)
            CustomTextIconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              title: "Upload another File",
              iconColor: Colors.white,
              bgColor: kCardGreenColor,
              txtColor: Colors.white,
              iconSize: 0,
              height: 35,
            )
          else
            Container(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomTextIconButton(
                onPressed: () {
                  context.read<FileUploadCubit>().showBanner();
                },
                title: "Test Data",
                icon: Icons.check,
                iconColor: Colors.white,
                bgColor: kSkyDarkColor,
                txtColor: Colors.white,
                iconSize: 24,
                height: 35,
              ),
              const SizedBox(width: 8),
              CustomTextIconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                title: "Cancel",
                icon: Icons.close,
                iconColor: Colors.white,
                bgColor: kTextFieldColor,
                txtColor: Colors.white,
                iconSize: 24,
                height: 35,
              ),
            ],
          ),
        ],
      );
    }
  }

  List<DataRow> _buildDataRows(BuildContext context, FileUploadState state) {
  if (state.tableData.isEmpty) return <DataRow>[];

  List<String> headers = state.customHeaders.isNotEmpty 
      ? state.customHeaders 
      : state.headers;

  // استخدام الأعمدة المختارة فقط، إذا كانت موجودة
  List<String> columnsToShow = state.selectedColumns.isNotEmpty 
      ? state.selectedColumns 
      : headers; // إذا لم يتم اختيار أي أعمدة، اعرض الكل

  // استخدام الصف الثاني من البيانات (الصف الأول بعد العناوين)
  List<dynamic> dataRow = state.tableData.length > 1 ? state.tableData[1] : [];
  
  return List.generate(columnsToShow.length, (colIndex) {
    final columnName = columnsToShow[colIndex];
    final originalIndex = headers.indexOf(columnName);
    final cellValue = originalIndex >= 0 && originalIndex < dataRow.length 
        ? dataRow[originalIndex]?.toString() ?? '' 
        : '';

    final bool shouldShowMissingData = state.showMissingData;
    final bool isEmptyCell = cellValue.trim().isEmpty;
    final bool showMissingDataWarning = shouldShowMissingData && isEmptyCell;

    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  columnName,
                  style: AppTextStyles.styleRegular14(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: state.selectedColumns.contains(columnName) ? Colors.blue : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                if (cellValue.isNotEmpty)
                  Text(
                    cellValue.length > 50 
                      ? cellValue.substring(0, 50) + '...' 
                      : cellValue,
                    style: AppTextStyles.styleRegular12(
                      context,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ),

        DataCell(
          StatefulBuilder(
            builder: (context, setStateRow) {
              final cubit = context.read<FileUploadCubit>();
              String? selectedItem = cubit.getSelectedDropdown(originalIndex);

              return SizedBox(
                width: 300,
                child: CustomDropDownWithSearch(
                  fldNm: "dbColumn_$columnName",
                  hint: "Select",
                  list: headers,
                  isRequired: false,
                  selectedItem: selectedItem,
                  onChanged: (val) {
                    setStateRow(() {
                      selectedItem = val;
                    });
                    cubit.setSelectedDropdown(originalIndex, val);
                    
                    // عند اختيار عمود من الدروب داون، أضفه/أزله من الأعمدة المعروضة
                    if (val != null) {
                      cubit.toggleColumnSelection(val);
                    }
                  },
                ),
              );
            },
          ),
        ),

        DataCell(
          Text(
            showMissingDataWarning ? 'Missing Data' : '',
            style: AppTextStyles.styleRegular14(context).copyWith(
              color: showMissingDataWarning ? Colors.red : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  });
}

  void _showCustomHeadersDialog(BuildContext context) {
  final cubit = context.read<FileUploadCubit>();
  final state = context.read<FileUploadCubit>().state;
  
  if (state.tableData.isEmpty) return;
  
  List<TextEditingController> controllers = [];
  
  // استخدام الصف الأول للعناوين
  List<dynamic> firstRow = state.tableData[0];
  
  for (int i = 0; i < firstRow.length; i++) {
    controllers.add(TextEditingController(
      text: state.customHeaders.isNotEmpty && i < state.customHeaders.length
          ? state.customHeaders[i]
          : firstRow[i]?.toString() ?? 'Column ${i + 1}'
    ));
  }
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Set Custom Headers"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Please define column headers for your data:"),
                const SizedBox(height: 20),
                ...List.generate(firstRow.length, (index) {
                  // الحصول على بيانات الصف الثاني كمثال
                  String sampleValue = '';
                  if (state.tableData.length > 1 && index < state.tableData[1].length) {
                    sampleValue = state.tableData[1][index]?.toString() ?? '';
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllers[index],
                            decoration: InputDecoration(
                              labelText: "Column ${index + 1} Header",
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Sample: ${sampleValue.length > 30 
                              ? sampleValue.substring(0, 30) + '...' 
                              : sampleValue}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              List<String> headers = controllers.map((c) => c.text).toList();
              cubit.setCustomHeaders(headers);
              Navigator.of(context).pop();
            },
            child: const Text("Save Headers"),
          ),
        ],
      );
    },
  );
}
}