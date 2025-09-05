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
    final bool hasEmptyCells = context
        .read<FileUploadCubit>()
        .cleanAndCheckEmptyCells(context.read<FileUploadCubit>().state.tableData);
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final TextStyle cellTextStyle =
            context.read<FileUploadCubit>().getCellTextStyle()
                ? AppTextStyles.styleRegular14(context,
                    color: const Color(0xff4b4b4b))
                : AppTextStyles.styleRegular14(context, color: Colors.white);

        final bool cleanAndCheckEmptyCells = context
            .read<FileUploadCubit>()
            .cleanAndCheckEmptyCells(state.tableData);

        // صف أول لاستخدامه في الـ Dropdown
        final List<String> firstRowValues = state.tableData.isNotEmpty
            ? state.tableData[0].map((e) => e.toString()).toList()
            : [];

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
],
            const HSpacer(10),

            // DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kSkyDarkColor),
                  headingRowHeight: 40,
                  headingTextStyle: AppTextStyles.styleRegular14(context,
                      color: Colors.white),
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 55,
                  columns: const [
                    DataColumn(label: Text("File Column")),
                    DataColumn(label: Text("Database Column")),
                    DataColumn(label: Text("Comments")),
                  ],
                  rows: state.tableData.map((row) {
                    final firstColumnValue =
                        row.isNotEmpty ? row[0].toString() : '';

                    return DataRow(
                      cells: [
                        // File Column
                        DataCell(
                          Text(firstColumnValue,
                              style: AppTextStyles.styleRegular14(context)),
                        ),

                        // Database Column مع Dropdown لكل صف
                       DataCell(
  StatefulBuilder(
    builder: (context, setStateRow) {
      final cubit = context.read<FileUploadCubit>();
      final rowIndex = state.tableData.indexOf(row);
      String? selectedItem = cubit.getSelectedDropdown(rowIndex);

      return SizedBox(
        width: 300,
        child: CustomDropDownWithSearch(
          fldNm: "dbColumn_$firstColumnValue",
          hint: "Select",
          list: firstRowValues, // القيم من الصف الأول فقط
          isRequired: false,
          selectedItem: selectedItem,
          onChanged: (val) {
            setStateRow(() {
              selectedItem = val;
            });

            // احفظ الاختيار في Cubit لكل صف
            cubit.setSelectedDropdown(rowIndex, val);

            debugPrint(
              "Selected Row Value in this row: $selectedItem",
            );
          },
        ),
      );
    },
  ),
),


                        // Comments
                        DataCell(
                          Text(
                            firstColumnValue.trim().isEmpty
                                ? 'Missing Data'
                                : '',
                            style: AppTextStyles.styleRegular14(context),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const HSpacer(20),

            // Bottom Buttons
            state.showMessage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextIconButton(
                        onPressed: () {
                          final cubit = context.read<FileUploadCubit>();
                          cubit.showTable();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ExcelGridViewer()),
                            );
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
                      const SizedBox(width: 8),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      ),
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
                  ),
          ],
        );
      },
    );
  }
}
