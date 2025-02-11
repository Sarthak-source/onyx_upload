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
import 'package:onyx_upload/features/upload_screen/presentation/widgets/main_page_table.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';

class TableReview extends StatelessWidget {
  // Local state for the checkbox.
  bool _makeFirstRowAddress = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final List<Map<String, String>> gridData =
            state.tableData.asMap().entries.map((entry) {
          final int index = entry.key;
          final row = entry.value;
          return {
            'fileColumn': state.headers[index],
            'dbColumn': row[index].toString(),
            'comments': row[index].toString().isEmpty ? 'Missing Data' : '',
          };
        }).toList();
        final mappingHeaders = context.read<FileUploadCubit>().mappingHeaders;

        final List<double> columnWidths = mappingHeaders
            .map<double>((header) => header.title.length * 18.0)
            .toList();

        // Determine the cell text style based on your cubit's logic.
        final TextStyle cellTextStyle =
            context.read<FileUploadCubit>().getCellTextStyle()
                ? AppTextStyles.styleRegular14(context,
                    color: const Color(0xff4b4b4b))
                : AppTextStyles.styleRegular14(context, color: Colors.white);

        final bool cleanAndCheckEmptyCells = context
            .read<FileUploadCubit>()
            .cleanAndCheckEmptyCells(state.tableData);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TitleDialogPage(title: 'Upload'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // Light gray background
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
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  Text(
                    "Make the first row in the file the address",
                    style: AppTextStyles.styleRegular14(context),
                  ),
                ],
              ),
            ),
            const HSpacer(15),
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
            // Message banner (shows warning if data is missing)
            state.showMessage
                ? MessageBanner(
                    message: cleanAndCheckEmptyCells
                        ? "Warning! Data Missing in line (1)."
                        : "Everything seems valid.",
                    backgroundColor: cleanAndCheckEmptyCells
                        ? kWarningMColor.shade300
                        : kSuccessMColor.shade300,
                    textColor: cleanAndCheckEmptyCells
                        ? kWarningMColor.shade500
                        : kSuccessMColor.shade500,
                  )
                : const SizedBox.shrink(),
            const HSpacer(10),
            // Wrap the DataTable in scroll views to allow for both vertical and horizontal scrolling.
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  // Set header background color and text style.
                  headingRowColor: WidgetStateProperty.all(kSkyDarkColor),
                  headingRowHeight: 40,
                  headingTextStyle: AppTextStyles.styleRegular14(context,
                      color: Colors.white),
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 55,
                  columnSpacing: 0,
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: columnWidths.isNotEmpty ? columnWidths[0] : null,
                        child: const Text(
                          "File Column",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: columnWidths.length > 1 ? columnWidths[1] : null,
                        child: const Text("Database Column",
                            textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: columnWidths.length > 2 ? columnWidths[2] : null,
                        child:
                            const Text("Comments", textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                  rows: gridData.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: columnWidths.isNotEmpty
                                ? columnWidths[0]
                                : null,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(row['fileColumn'] ?? '',
                                    style: cellTextStyle.copyWith(
                                        fontSize: 12,
                                        color: const Color(0xff819AA7))),
                                Text(
                                  row['dbColumn'] ?? '',
                                  style: cellTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Add cell tap functionality if needed.
                          },
                        ),
                        DataCell(
                          SizedBox(
                            width: columnWidths.length > 1.2
                                ? columnWidths[1]
                                : null,
                            child: CustomDropDownWithSearch(
                              fldNm: "dbColumn",
                              hint: row['fileColumn'] ?? '',
                              labelText: row['fileColumn'] ?? '',
                              list: const [
                                "External ID",
                                "Product ID",
                                "Pricing",
                                "Variant ID"
                              ],
                              isRequired: false,
                              selectedItem: state.customDropdownTable,
                              onChanged: (value) {
                                context
                                    .read<FileUploadCubit>()
                                    .textTable(value);
                              },
                            ),
                          ),
                          onTap: () {},
                        ),
                        DataCell(
                          SizedBox(
                            width: columnWidths.length > 2
                                ? columnWidths[2]
                                : null,
                            child: Text(row['comments'] ?? '',
                                style: cellTextStyle),
                          ),
                          onTap: () {},
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const HSpacer(20),
            // Bottom buttons – show different button sets based on state.showMessage
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
                              // ignore: use_build_context_synchronously
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
